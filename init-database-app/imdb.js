require('dotenv').config();
const mysql = require('mysql');

function createConnection() {
    const connection = mysql.createConnection({
        host     : process.env.RDS_HOSTNAME,
        user     : process.env.RDS_USERNAME,
        password : process.env.RDS_PASSWORD,
        port     : process.env.RDS_PORT,
        multipleStatements: true
    });
    
    connection.config.queryFormat = function (query, values) {
        if (!values) return query;
        return query.replace(/\:(\w+)/g, function (txt, key) {
        if (values.hasOwnProperty(key)) {
            return this.escape(values[key]);
        }
        return txt;
        }.bind(this));
    };
    return connection;
}


async function execSql11(connection, sql, params) {
    return new Promise((resolve, reject)=>{
      connection.query(sql, params, function (error, results, fields) {
        if (error) return reject(error);
        resolve(results);   
      });
    });  
}

function execSql(connection, query, params) {
    let result;
    connection.connect();

    connection.query(query, params, function (error, results, fields) {
      if (error) throw error
      result = results;
    })

    return new Promise( ( resolve, reject ) => {
        connection.end( err => {
            if ( err )
                return reject( err )
                resolve(result); 
        })
    })
}


//CALL `imdb`.`filter_movie_by_director_or_genre_paginated`(<{in seek int}>, <{in size int}>, <{in director_name varchar(50)}>, <{in gen varchar(50)}>);
exports.getMovieByDirectorOrGenrePaginated =  (page=0, size=100, director="", genre="") => {
    const connection = createConnection();
    let res =   execSql(connection, `call imdb.filter_movie_by_director_or_genre_paginated(:seek, :size, :direct, :genre);`, 
    {
        "seek":page*size,
        "size":size,
        "direct":director,
        "genre":genre
    });
    return res;
}

//CALL `imdb`.`get_actor_stats`(<{in actorId int}>);
exports.getActorStatistics =  (actorId) => {
    const connection = createConnection();
    let res =  execSql(connection, `call imdb.get_actor_stats(:id);`, {"id":actorId});
    return res;
}
