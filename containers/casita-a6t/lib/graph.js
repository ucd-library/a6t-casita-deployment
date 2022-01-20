import goesrMsgDecorder from './goesr-message-decoder.js';
import airflow from './airflow.js';
import pathUtils from 'path';

const GENERIC_PAYLOAD_APIDS = /^(301|302)$/;

const dag = {

  'goesr-product' : {
    source : true,
    decoder : goesrMsgDecorder 
  },



  'block-composite-image' : {
    dependencies : ['goesr-product'],

    where : msg => ['image-fragment.jp2', 'fragment-metadata.json'].includes(msg.path.filename),
    groupBy : msg => `${msg.scale}-${msg.date}-${msg.hour}-${msg.minsec}-${msg.band}-${msg.apid}-${msg.block}`,
    expire : 60 * 2,
    
    ready : msgs => {
      let fragments = msgs.filter(item => item.path.filename === 'image-fragment.jp2');
      let metadata = msgs.filter(item => item.path.filename === 'fragment-metadata.json');
      
      if( !metadata.length ) return false;
      return (metadata[0].metadata.fragmentsCount === fragments.length);
    },

    sink : (key, msgs) => {
      let {scale, date, hour, minsec, band, apid, block, path} = msgs[0];
      path.directory = pathUtils.resolve(path.directory, '..');

      return airflow.runDag(key, 'block-composite-images', {
        scale, date, hour, minsec, band, apid, block, path
      });
    }
  },



  'full-composite-image' : {
    dependencies : ['block-composite-images'],

    groupBy : msg => `${msg.scale}-${date}-${hour}-${minsec}-${band}-${apid}-${path.filename}`,
    where : data => ['image.png', 'web.png', 'web-scaled.png'].includes(data.path.filename),
    expire : 60 * 20,

    ready : msgs => {
      let scale = msgs[0].scale;

      // TODO: wish there was a better way
      if( scale === 'mesoscale' && msgs.length >= 4 ) return true;
      if( scale === 'conus' && msgs.length >= 36 ) return true;
      if( scale === 'fulldisk' && msgs.length >= 229 ) return true;

      return false;
    },

    sink : (key, msgs) => {
      let {scale, date, hour, minsec, band, apid, block, path} = msgs[0];

      return airflow.runDag(key, 'full-composite-image', {
        scale, date, hour, minsec, band, apid, block, path
      });
    },
  },



  'generic-payload-parser' : {
    dependencies : ['goesr-product'],

    where : data => (data.apid.match(GENERIC_PAYLOAD_APIDS) ? true : false) && (data.path.filename === 'payload.bin'),

    sink : (key, msgs) => {
      let {scale, date, hour, minsec, ms, band, apid, block, path} = msgs[0];

      return airflow.runDag(key, 'generic-payload-parser', {
          scale, date, hour, minsec, ms, band, apid, block, path
      });
    }
  },

  'lighting-grouped-stats' : {

  }


}

export default dag