import fetch from 'node-fetch';
const BASE_API = process.env.AIRFLOW_BASE_API || 'http://airflow/api/v1/dags';

class Airflow {

  runDag(key, dagId, conf) {

    const body = {
      dag_run_id : key,
      logical_date : new Date().toISOString(),
      conf
    }
  
    console.log(
      'SENDING!!!!!',
      [BASE_API, dagId, 'dagRuns'].join('/'), 
      {
        method : 'POST',
        headers : {'content-type': 'application/json'}, 
        body : JSON.stringify(body)
      }
    );
  
    // return _callPostApi([BASE_API, dagId, 'dagRuns'].join('/'), body);
    return {success: true};
  }

  async _callPostApi(path, body) {
    try { 
      let response = await fetch(
        [BASE_API, path].join('/'),
        {
          method : 'POST',
          headers : {'content-type': 'application/json'}, 
          body : JSON.stringify(body)
        }
      );

      if( response.status < 200 || response.status > 299 ) {
        return { 
          success: false, 
          message: `failed to send ${key} to dag. status=${response.status} body=`+(await response.text())
        }
      }
    } catch(e) {
      return {
        success : false,
        message : `failed to send ${key} to dag: ${e.message}`
      }
    }

    return {success: true}
  }

}

const airflow = new Airflow();
export default airflow;