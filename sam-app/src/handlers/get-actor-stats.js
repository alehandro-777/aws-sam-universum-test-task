const repo = require('../db/imdb');

exports.getActorStatsHandler = async (event) => {
  if (event.httpMethod !== 'GET') {
    throw new Error(`getMethod only accept GET method, you tried: ${event.httpMethod}`);
  }
  // All log statements are written to CloudWatch
  console.info('received:', event);
 
  // Get id from pathParameters from APIGateway because of `/{id}` at template.yaml
  const id = event.pathParameters.id;
 
  let response = {};

  try {

    const data = await repo.getActorStatistics(id);
  
    if (data.length == 0) throw ResourceNotFoundException;
    if (data[0].length == 0) throw ResourceNotFoundException;
    
    const item = data[0][0];
   
    response = {
      statusCode: 200,
      body: JSON.stringify(item)
    };
  } catch (ResourceNotFoundException) {
    response = {
        statusCode: 404,
        body: "Actor not found."
    };
  }
 
  // All log statements are written to CloudWatch
  console.info(`response from: ${event.path} statusCode: ${response.statusCode} body: ${response.body}`);
  return response;
}
