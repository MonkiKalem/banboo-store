const connection = require('../database/connect');

async function queryAsync (query, params = []) {  
  return new Promise((resolve, reject) => {  
    connection.query(query, params, (err, results) => {  
      if (err) return reject(err);  
      resolve(results);  
    });  
  });  
};  

module.exports = {
  queryAsync
}