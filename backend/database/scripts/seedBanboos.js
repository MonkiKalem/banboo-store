const connection = require('../connect');

const seedBanboos = async () => {
  try {

    await queryAsync('USE db_banboo');  

    const banboos = [  
      {  
        name: 'Amillion',  
        description: 'A brave and cunning Banboo ready to face any challenge. Known for its resilience in battle, Amillion always stands by its allies.',  
        price: 2500000,  
        level: 5,  
        elementId: 1, // Fire  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/amillion.png',  
      },  
      {  
        name: 'Bangvolver',  
        description: 'This tech-savvy Banboo specializes in gadgetry and sophisticated weaponry. Its clever inventions provide tactical advantages in combat.',  
        price: 2700000,  
        level: 6,  
        elementId: 2, // Wind  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/bangvolver.png',  
      },  
      {  
        name: 'Butler',  
        description: 'A distinguished Banboo that excels in service and combat support. With impeccable manners and strategic insights, Butler is a dependable companion.',  
        price: 2200000,  
        level: 4,  
        elementId: 2, // Wind  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/butler.png',  
      },  
      {  
        name: 'Officer Cui',  
        description: 'This Banboo is a disciplined law enforcer, dedicated to bringing order to chaos. Officer Cui excels in crowd control and tactical operations.',  
        price: 2400000,  
        level: 5,  
        elementId: 4, // Ice  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/officer_cui.png',  
      },  
      {  
        name: 'Plugboo',  
        description: 'An energetic Banboo with electrical abilities, Plugboo is known for charging up its allies in combat, boosting their capabilities.',  
        price: 2600000,  
        level: 5,  
        elementId: 3, // Water  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/plugboo.png',  
      },  
      {  
        name: 'Red Moccus',  
        description: 'A charming yet mischievous Banboo. With a playful personality, Red Moccus often confuses enemies, giving its allies an upper hand in battle.',  
        price: 2300000,  
        level: 4,  
        elementId: 1, // Fire  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/red_moccus.png',  
      },  
      {  
        name: 'Rocketboo',  
        description: 'This adventurous Banboo loves to explore. With its soaring abilities, Rocketboo scouts the terrain ahead, providing valuable intel.',  
        price: 2500000,  
        level: 4,  
        elementId: 2, // Wind  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/rocketboo.png',  
      },  
      {  
        name: 'Safety',  
        description: 'A defensive Banboo designed to protect its allies. Safety uses its robust capabilities to shield teammates from harm.',  
        price: 2800000,  
        level: 5,  
        elementId: 3, // Water  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/safety.png',  
      },  
      {  
        name: 'Sharkboo',  
        description: 'A fierce and loyal companion with water-based abilities. Sharkboo can turn the tide of battle with its powerful attacks.',  
        price: 3000000,  
        level: 6,  
        elementId: 3, // Water  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/sharkboo.png',  
      },  
      {  
        name: 'Avocaboo',  
        description: 'A quirky and lovable Banboo, Avocaboo uses its unique charm to distract enemies and create openings for its team.',  
        price: 2100000,  
        level: 3,  
        elementId: 1, // Fire  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/avocaboo.png',  
      },  
      {  
        name: 'Baddieboo',  
        description: 'A cunning trickster Banboo known for its misdirection tactics. Baddieboo confounds enemies with playful tricks and swift maneuvers.',  
        price: 2200000,  
        level: 4,  
        elementId: 2, // Wind  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/baddieboo.png',  
      },  
      {  
        name: 'Bagboo',  
        description: 'Known for its collection skills, Bagboo can gather valuable resources during missions. Its clever strategies ensure resource efficiency.',  
        price: 1800000,  
        level: 3,  
        elementId: 4, // Ice  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/bagboo.png',  
      },  
      {  
        name: 'Boolseye',  
        description: 'An exceptional marksman, Boolseye never misses a target. This Banboo is essential for long-range combat scenarios.',  
        price: 2900000,  
        level: 5,  
        elementId: 1, // Fire  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/boolseye.png',  
      },  
      {  
        name: 'Booressure',  
        description: 'With its ability to control pressure, Booressure manipulates enemies in combat, creating havoc among opponents.',  
        price: 2300000,  
        level: 4,  
        elementId: 3, // Water  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/booressure.png',  
      },  
      {  
        name: 'Cryboo',  
        description: 'This icy Banboo utilizes freeze abilities to immobilize foes, making it a formidable force in battle.',  
        price: 2400000,  
        level: 5,  
        elementId: 4, // Ice  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/cryboo.png',  
      },  
      {  
        name: 'Devilboo',  
        description: 'A mysterious Banboo known for its dark abilities. Devilboo can invoke fear in its enemies, shifting the balance of power in battle.',  
        price: 3200000,  
        level: 6,  
        elementId: 1, // Fire  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/devilboo.png',  
      },  
      {  
        name: 'Electroboo',  
        description: 'A high-voltage Banboo capable of discharging electricity in combat. Electroboo powers up allies and delivers shocking attacks.',  
        price: 2750000,  
        level: 5,  
        elementId: 2, // Wind  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/electroboo.png',  
      },  
      {  
        name: 'Exploreboo',  
        description: 'An adventurous Banboo that excels in scouting platforms and terrains, ensuring a safe path for its teammates.',  
        price: 2000000,  
        level: 3,  
        elementId: 3, // Water  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/exploreboo.png',  
      },  
      {  
        name: 'Knightboo',  
        description: 'The brave defender of the team, Knightboo uses its strength to shield allies from impending danger.',  
        price: 2800000,  
        level: 5,  
        elementId: 4, // Ice  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/knightboo.png',  
      },  
      {  
        name: 'Magnetiboo',  
        description: 'This magnetic Banboo attracts resources and items, making it a valuable ally during missions.',  
        price: 2100000,  
        level: 4,  
        elementId: 1, // Fire  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/magnetiboo.png',  
      },  
      {  
        name: 'Paperboo',  
        description: 'An agile Banboo known for its ability to evade and confuse enemies. Paperboo’s agility allows it to maneuver through threats effortlessly.',  
        price: 2300000,  
        level: 4,  
        elementId: 2, // Wind  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/paperboo.png',  
      },  
      {  
        name: 'Penguinboo',  
        description: 'With a cool demeanor and strategic mind, Penguinboo is a powerhouse ready for any challenge that comes its way.',  
        price: 2450000,  
        level: 4,  
        elementId: 3, // Water  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/penguinboo.png',  
      },  
      {  
        name: 'Sumoboo',  
        description: 'A strong and sturdy Banboo, Sumoboo brings its massive strength into battle, making it a key player in defensive strategies.',  
        price: 3000000,  
        level: 6,  
        elementId: 4, // Ice  
        imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/sumoboo.png',  
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
