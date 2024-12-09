const connection = require('../connect');

const seedBanboos = async () => {
  try {

    await queryAsync('USE db_banboo');  

    const banboos = [
      {
        name: 'Amillion',
        description: 'ehehehehe',
        price: 3324500,
        level: 2,
        elementId: 1,
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/amillion.png',
      },
      {
        name: 'Butler',
        description: 'Another Banboo dollawdaawdawaw',
        price: 1635000,
        level: 4,
        elementId: 2,
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/butler.png',
      },
      {
        name: 'Sharkboo',
        description: 'Another Banboo doll',
        price: 1520000,
        level: 6,
        elementId: 3,
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/sharkboo.png',
      },
      {
        name: 'Officer Cui',
        description: 'Awoo! Woof Woof!',
        price: 2120000,
        level: 6,
        elementId: 2,
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/officer_cui.png',
      },
    ];

    for (let banboo of banboos) {
      const checkQuery = 'SELECT * FROM banboos WHERE name = ?';
      const [existingBanboo] = await queryAsync(checkQuery, [banboo.name]);

      if (existingBanboo) {
        console.log(`Banboo "${banboo.name}" already exists, not continue add.`);
      } else {
        // Menambahkan banboo baru jika belum ada
        const insertQuery = `INSERT INTO banboos (name, description, price, level, elementId, imageUrl) 
                             VALUES (?, ?, ?, ?, ?, ?)`;
        await queryAsync(insertQuery, [
          banboo.name,
          banboo.description,
          banboo.price,
          banboo.level,
          banboo.elementId,
          banboo.imageUrl,
        ]);
        console.log(`Banboo "${banboo.name}" added.`);
      }
    }

    console.log('Seeder Finish: Banboos has checked and added (if not exists).');
  } catch (err) {
    console.error('Error when seeding Banboos:', err.message);
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

// Jalankan fungsi seeder
seedBanboos();
