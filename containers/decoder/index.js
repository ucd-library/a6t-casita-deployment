import Processor from '@ucd-lib/goes-r-packet-decoder/lib/binary-stream-processor'
import {logger} from '@ucd-lib/argonaut';
import kafkaSetup from './default-kafka-setup.js';

let processor = new Processor({
  name : process.env.GRB_FILE,
  consoleLogStatus : false,
  onStreamClosed : () => logger.warn(`${process.env.GRB_FILE} grb tail stream closed`),
  kafka : kafkaSetup
});

processor.pipe();