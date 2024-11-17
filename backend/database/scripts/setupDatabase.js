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
                description TEXT
            )
        `);
        console.log('Elements table created.');

        // Create banboos table
        await queryAsync(`
            CREATE TABLE IF NOT EXISTS banboos (
                banbooId INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                price DECIMAL(10, 2) NOT NULL,
                description TEXT,
                elementId INT,
                level TINYINT NOT NULL,
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
                totalPrice DECIMAL(10, 2) NOT NULL,
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
                price DECIMAL(10, 2) NOT NULL,
                FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
                FOREIGN KEY (banbooId) REFERENCES banboos(banbooId) ON DELETE CASCADE
            )
        `);
        console.log('Order Items table created.');
    } catch (err) {
        console.error('Error during database setup:', err.message);
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

// Run the setup
setupDatabase();
