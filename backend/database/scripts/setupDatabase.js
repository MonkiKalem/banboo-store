const connection = require('../connect');

// Create database and tables
const setupDatabase = async () => {
    try {
        // Create the database if it doesn't exist
        await queryAsync('CREATE DATABASE IF NOT EXISTS db_banboo');
        console.log('Database created or already exists.');
        
        // Switch to the database
        await queryAsync('USE db_banboo');
        console.log('Using db_banboo.');

        // Create users table
        await queryAsync(`
            CREATE TABLE IF NOT EXISTS users (
                userId INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                email VARCHAR(150) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                google_id VARCHAR(255) UNIQUE,  
                profile_picture VARCHAR(500) NOT NULL DEFAULT 'https://preview.redd.it/zenless-zone-zero-icon-v0-9ss6qz6tuwx81.png?width=1080&crop=smart&auto=webp&s=3818f47bf93f33a46ec714258e552ac0363873c6', 
                is_google_user BOOLEAN DEFAULT FALSE,
                role ENUM('admin', 'customer') NOT NULL DEFAULT 'customer',
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `);
        console.log('Users table created.');

        // Create elements table
        await queryAsync(`
            CREATE TABLE IF NOT EXISTS elements (
                elementId INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                elementIcon VARCHAR(500) NOT NULL,
                description TEXT
            )
        `);
        console.log('Elements table created.');

        // Create banboos table
        await queryAsync(`
            CREATE TABLE IF NOT EXISTS banboos (
                banbooId INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                price INT NOT NULL,
                description TEXT,
                elementId INT,
                level TINYINT NOT NULL,
                imageUrl VARCHAR(500) NOT NULL,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                FOREIGN KEY (elementId) REFERENCES elements(elementId) ON DELETE SET NULL
            )
        `);
        console.log('Banboos table created.');


        // Create orders table
        await queryAsync(`
            CREATE TABLE IF NOT EXISTS orders (
                orderId INT AUTO_INCREMENT PRIMARY KEY,
                userId INT NOT NULL,
                totalPrice INT NOT NULL,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE
            )
        `);
        console.log('Orders table created.');

        // Create order_items table
        await queryAsync(`
            CREATE TABLE IF NOT EXISTS order_items (
                orderItemId INT AUTO_INCREMENT PRIMARY KEY,
                orderId INT NOT NULL,
                banbooId INT NOT NULL,
                quantity INT NOT NULL,
                price INT NOT NULL,
                FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
                FOREIGN KEY (banbooId) REFERENCES banboos(banbooId) ON DELETE CASCADE
            )
        `);
        console.log('Order Items table created.');

           // Create cart table  
        await queryAsync(`  
            CREATE TABLE IF NOT EXISTS carts (  
                cartId INT AUTO_INCREMENT PRIMARY KEY,  
                userId INT NOT NULL,  
                totalPrice INT NOT NULL DEFAULT 0,  
                status ENUM('active', 'converted', 'abandoned') DEFAULT 'active',  
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
                FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE  
            )
        `);  
        console.log('Cart table created.');  

        // Create cart_items table  
        await queryAsync(`  
            CREATE TABLE IF NOT EXISTS cart_items (  
                cartItemId INT AUTO_INCREMENT PRIMARY KEY,  
                cartId INT NOT NULL,  
                banbooId INT NOT NULL,  
                quantity INT NOT NULL,  
                price INT NOT NULL,  
                FOREIGN KEY (cartId) REFERENCES carts(cartId) ON DELETE CASCADE,  
                FOREIGN KEY (banbooId) REFERENCES banboos(banbooId) ON DELETE CASCADE  
            )  
        `);  
        console.log('Cart Items table created.');  

   
    } catch (err) {
        console.error('Error during database setup:', err.message);
    } finally {
        connection.end();
    }
    console.log('');
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

// Run the setup
setupDatabase();
