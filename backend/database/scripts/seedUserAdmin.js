const connection = require('../connect');  
const bcrypt = require('bcrypt');  

const seedUsers = async () => {  
  try {  
    await queryAsync('USE db_banboo');  

    const adminUsers = [  
      {  
        name: 'Super Admin Banboo',  
        email: 'admin@zzz.com',  
        password: '123123',
        role: 'admin',
        profile_picture: 'https://static.wikia.nocookie.net/zenless-zone-zero/images/6/63/NPC_Bangboo_18_Icon.png/revision/latest?cb=20240803023246'  
      },  

    ];  

    for (let user of adminUsers) {  
      // Cek apakah user sudah ada  
      const checkQuery = 'SELECT * FROM users WHERE email = ?';  
      const [existingUser] = await queryAsync(checkQuery, [user.email]);  

      if (existingUser) {  
        console.log(`User with email "${user.email}" already exists, skipping.`);  
        continue;  
      }  

      // Hash password sebelum disimpan  
      const saltRounds = 10;  
      const hashedPassword = await bcrypt.hash(user.password, saltRounds);  

      // Tambahkan user baru  
      const insertQuery = `  
        INSERT INTO users   
        (name, email, password, role)   
        VALUES (?, ?, ?, ?)  
      `;  
      
      await queryAsync(insertQuery, [  
        user.name,  
        user.email,  
        hashedPassword,  
        user.role  
      ]);  

      console.log(`Admin user "${user.name}" added successfully.`);  
    }  

    console.log('Seeder Finish: Admin users checked and added (if not exists).');  
  } catch (err) {  
    console.error('Error when seeding Users:', err.message);  
  } finally {  
    connection.end();  
  }  
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
seedUsers();