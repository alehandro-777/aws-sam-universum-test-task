const db = require('./imdb');

async function Call() {
    try {  

      let res = await db.getMovieByDirectorOrGenrePaginated();  
      console.log(res[0]);
      
      res = await db.getActorStatistics(1234);  
      console.log(res[0]);

      process.exit(0);

    } catch (error) {  
      console.log(error);
    }  
  }
  
  //CreateDatabase(connection);
  Call();