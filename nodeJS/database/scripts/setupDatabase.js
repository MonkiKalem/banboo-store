const connection = require('./database/connect');

// Create database
connection.query('CREATE DATABASE IF NOT EXISTS db_banboo', (err, results) => {
    if (err) throw err;
    console.log('Database created or already exists.');

    // Switch to the database
    connection.query('USE db_banboo', (err) => {
        if (err) throw err;
        console.log('Using db_banboo.');

        // Create users table
        connection.query(`
            CREATE TABLE IF NOT EXISTS users (
                userId INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                email VARCHAR(150) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                role ENUM('admin', 'customer') NOT NULL DEFAULT 'customer',
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `, (err) => {
            if (err) throw err;
            console.log('Users table created.');
        });

        // Create elements table
        connection.query(`
            CREATE TABLE IF NOT EXISTS elements (
                elementId INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                description TEXT
            )
        `, (err) => {
            if (err) throw err;
            console.log('Elements table created.');
        });

        // Create banboos table
        connection.query(`
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
        `, (err) => {
            if (err) throw err;
            console.log('Banboos table created.');
        });

        // Create orders table
        connection.query(`
            CREATE TABLE IF NOT EXISTS orders (
                orderId INT AUTO_INCREMENT PRIMARY KEY,
                userId INT NOT NULL,
                totalPrice DECIMAL(10, 2) NOT NULL,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE
            )
        `, (err) => {
            if (err) throw err;
            console.log('Orders table created.');
        });

        // Create order_items table
        connection.query(`
            CREATE TABLE IF NOT EXISTS order_items (
                orderItemId INT AUTO_INCREMENT PRIMARY KEY,
                orderId INT NOT NULL,
                banbooId INT NOT NULL,
                quantity INT NOT NULL,
                price DECIMAL(10, 2) NOT NULL,
                FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
                FOREIGN KEY (banbooId) REFERENCES banboos(banbooId) ON DELETE CASCADE
            )
        `, (err) => {
            if (err) throw err;
            console.log('Order Items table created.');
        });
    });
});

// Close connection when done
connection.end();
