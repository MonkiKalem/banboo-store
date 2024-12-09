const connection = require('../connect');  

// Function to delete the database  
const deleteDatabase = async () => {  
    try {  
        // Drop the database if it exists  
        await queryAsync('DROP DATABASE IF EXISTS db_banboo');  
        console.log('Database db_banboo has been deleted (if it existed).');  
    } catch (err) {  
        console.error('Error when deleting database:', err.message);  
    } finally {  
        connection.end();  
    }  
};  

// Utility function to promisify connection.query  
const queryAsync = (query, params = []) => {  
    return new Promise((resolve, reject) => {  
        connection.query(query, params, (err, results) => {  
            if (err) return reject(err);  
            resolve(results);  
        });  
    });  
};  

// Run the delete database function  
deleteDatabase();