const repo = require('../db/imdb');

exports.getMoviesHandler = async (event) => {
  if (event.httpMethod !== 'GET') {
    throw new Error(`getMethod only accept GET method, you tried: ${event.httpMethod}`);
  }
  // All log statements are written to CloudWatch
  console.info('received:', event);
  
  let query = event.queryStringParameters ? event.queryStringParameters : {};

  // Get params from  from APIGateway 
  const { page=0, size=30, director="", genre="" } = query;
 
  let response = {};

  try {

    const data = await repo.getMovieByDirectorOrGenrePaginated( page, size, director, genre);
    
    if (data.length == 0) throw ResourceNotFoundException;
    
    const item = data[0];
   
    response = {
      statusCode: 200,
      body: JSON.stringify(item)
    };
  } catch (ResourceNotFoundException) {
    response = {
        statusCode: 404,
        body: "Movies not found."
    };
  }
 
  // All log statements are written to CloudWatch
  console.info(`response from: ${event.path} statusCode: ${response.statusCode} body: ${response.body}`);
  return response;
}