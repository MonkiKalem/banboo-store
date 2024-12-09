const connection = require('../connect');  

const seedElements = async () => {  
  try {  

    await queryAsync('USE db_banboo');  
  
    const elements = [  
      {  
        name: 'Pyro',  
        description: 'Represents the element of fire, associated with energy and passion.',  
      },  
      {  
        name: 'Hydro',  
        description: 'Represents the element of water, associated with fluidity and adaptability.',  
      },  
      {  
        name: 'Geo',  
        description: 'Represents the element of earth, associated with stability and growth.',  
      },  
      {  
        name: 'Anemo',  
        description: 'Represents the element of air, associated with freedom and intellect.',  
      },  
    ];  

    for (let element of elements) {  
      const checkQuery = 'SELECT * FROM elements WHERE name = ?';  
      const [existingElement] = await queryAsync(checkQuery, [element.name]);  

      if (existingElement) {  
        console.log(`Element "${element.name}" already exists, not continue add.`);  
      } else {  
        // Menambahkan element baru jika belum ada  
        const insertQuery = `INSERT INTO elements (name, description)   
                             VALUES (?, ?)`;  
        await queryAsync(insertQuery, [  
          element.name,  
          element.description,  
        ]);  
        console.log(`Element "${element.name}" added.`);  
      }  
    }  

    console.log('Seeder Finish: Elements has checked and added (if not exists).');  
  } catch (err) {  
    console.error('Error when seeding Elements:', err.message);  
  } finally {  
    connection.end();  
  }  
  console.log('');
};  

// Utility function untuk promisify connection.query  
const queryAsync = (query, params = []) => {  
  return new Promise((resolve, reject) => {  
    connection.query(query, params, (err, results) => {  
      if (err) return reject(err);  
      resolve(results);  
    });  
  });  
};  

seedElements();