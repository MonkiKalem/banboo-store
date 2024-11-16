const express = require('express');
const router = express.Router();
const connection = require('../database/connect');
const { authenticateToken, isAdmin } = require('../middleware/authMiddleware');

// Get all banboos with their elements
router.get('/', (req, res) => {
    const query = `
        SELECT b.banbooId, b.name, b.price, b.description, b.level, b.createdAt, b.updatedAt, 
               e.name AS elementName, e.description AS elementDescription
        FROM banboos b
        LEFT JOIN elements e ON b.elementId = e.elementId;
    `;
    connection.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Get a specific banboo by ID with element details
router.get('/:id', (req, res) => {
    const { id } = req.params;
    const query = `
        SELECT b.banbooId, b.name, b.price, b.description, b.level, b.createdAt, b.updatedAt, 
               e.name AS elementName, e.description AS elementDescription
        FROM banboos b
        LEFT JOIN elements e ON b.elementId = e.elementId
        WHERE b.banbooId = ?;
    `;
    connection.query(query, [id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(404).json({ error: 'Banboo not found' });
        res.json(results[0]);
    });
});

// Secure Routes
router.post('/', authenticateToken, isAdmin, (req, res) => {
    const { name, price, description, elementId, level } = req.body;
    connection.query('INSERT INTO banboos (name, price, description, elementId, level) VALUES (?, ?, ?, ?, ?)',
        [name, price, description, elementId, level], (err, results) => {
            if (err) return res.status(500).json({ error: err.message });
            res.status(201).json({ message: 'Banboo added successfully', banbooId: results.insertId });
        });
});

router.put('/:id', authenticateToken, isAdmin, (req, res) => {
    const { id } = req.params;
    const { name, price, description, elementId, level } = req.body;
    connection.query('UPDATE banboos SET name = ?, price = ?, description = ?, elementId = ?, level = ? WHERE banbooId = ?',
        [name, price, description, elementId, level, id], (err, results) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: 'Banboo updated successfully' });
        });
});

router.delete('/:id', authenticateToken, isAdmin, (req, res) => {
    const { id } = req.params;
    connection.query('DELETE FROM banboos WHERE banbooId = ?', [id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Banboo deleted successfully' });
    });
});

// Non-admin routes (e.g., view Banboos)
router.get('/', (req, res) => {
    connection.query('SELECT * FROM banboos', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});


module.exports = router;
