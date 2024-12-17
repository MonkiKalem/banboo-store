const connection = require('../connect');  

const seedElements = async () => {  
  try {  

    await queryAsync('USE db_banboo');  
  
    const elements = [  
      {  
        name: 'Pyro', 
        elementIcon: 'https://static.wikia.nocookie.net/gensin-impact/images/e/e8/Element_Pyro.png/revision/latest/scale-to-width-down/30?cb=20201116063114', 
        description: 'Represents the element of fire, associated with energy and passion.',  
      },  
      {  
        name: 'Hydro',  
        elementIcon: 'https://static.wikia.nocookie.net/gensin-impact/images/3/35/Element_Hydro.png/revision/latest/scale-to-width-down/30?cb=20201116063105',
        description: 'Represents the element of water, associated with fluidity and adaptability.',  
      },  
      {  
        name: 'Geo',  
        elementIcon: 'https://static.wikia.nocookie.net/gensin-impact/images/4/4a/Element_Geo.png/revision/latest/scale-to-width-down/30?cb=20201116063036',
        description: 'Represents the element of earth, associated with stability and growth.',  
      },  
      {  
        name: 'Anemo',  
        elementIcon: 'https://static.wikia.nocookie.net/gensin-impact/images/a/a4/Element_Anemo.png/revision/latest/scale-to-width-down/30?cb=20201116063017',
        description: 'Represents the element of air, associated with freedom and intellect.',  
      },  
      {  
        name: 'Cryo',  
        elementIcon: 'https://static.wikia.nocookie.net/gensin-impact/images/8/88/Element_Cryo.png/revision/latest/scale-to-width-down/30?cb=20201116063123',
        description: 'Represents the element of earth, associated with stability and growth.',  
      },  
      {  
        name: 'Electro',  
        elementIcon: 'https://static.wikia.nocookie.net/gensin-impact/images/7/73/Element_Electro.png/revision/latest/scale-to-width-down/30?cb=20201116063049',
        description: 'Represents the element of earth, associated with stability and growth.',  
      },  
       
    ];  

    for (let element of elements) {  
      const checkQuery = 'SELECT * FROM elements WHERE name = ?';  
      const [existingElement] = await queryAsync(checkQuery, [element.name]);  

      if (existingElement) {  
        console.log(`Element "${element.name}" already exists, not continue add.`);  
      } else {  
        // Menambahkan element baru jika belum ada  
        const insertQuery = `INSERT INTO elements (name, elementIcon, description)   
                             VALUES (?,?, ?)`;  
        await queryAsync(insertQuery, [  
          element.name, 
          element.elementIcon,  
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