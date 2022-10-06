require('dotenv').config();
const mysql = require('mysql');
const fs = require('fs')

const connection = mysql.createConnection({
  host     : process.env.RDS_HOSTNAME,
  user     : process.env.RDS_USERNAME,
  password : process.env.RDS_PASSWORD,
  port     : process.env.RDS_PORT,
  multipleStatements: true
});


const argv = require('minimist')(process.argv.slice(2));

if (!argv.path) {
  console.error("ERROR: --path parameter missing");
  process.exit(1);
}

async function readFile(file) {
  return new Promise((resolve, reject)=>{
    fs.readFile( file, 'utf8', function(err, data) {
      if (err) return reject(err);
      resolve(data);    
    });
  });  
}

async function execSql(connection, sql) {
  return new Promise((resolve, reject)=>{
    connection.query(sql, function (error, results, fields) {
      if (error) return reject(error);
      resolve(results);   
    });
  });  
}

//CALL `imdb`.`get_actor_movies`(<{in actorId int}>);
//CALL `imdb`.`filter_movie_by_director_or_genre_paginated`(<{in seek int}>, <{in size int}>, <{in director_name varchar(50)}>, <{in gen varchar(50)}>);
//CALL `imdb`.`get_actor_stats`(<{in actorId int}>);

async function CreateDatabase(connection) {
  try {

    let sql = await readFile(process.env.SQL_CREARE);
    console.log("Create script read Ok");
    let res = await execSql(connection, sql);
    console.log("Database created Ok");

    sql = await readFile(process.env.SQL_LOAD);
    console.log("Load script read Ok");

    sql = sql.replace(/{path}/g, argv.path);

    res = await execSql(connection, sql);    
    console.log("Database load dataset Ok");
  } catch (error) {
  
    console.log(error);
  
  } finally {
    connection.destroy();  
  }  
}



CreateDatabase(connection);
