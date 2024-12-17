const express = require('express');
const router = express.Router();
const connection = require('../database/connect');
const { authenticateToken, isAdmin } = require('../middleware/authMiddleware');

// Utility function to promisify connection.query
const queryAsync = (query, params = []) => {
    return new Promise((resolve, reject) => {
        connection.query(query, params, (err, results) => {
            if (err) return reject(err);
            resolve(results);
        });
    });
};

// Middleware untuk inisialisasi database
router.use(async (req, res, next) => {
    await queryAsync('USE db_banboo');
    next();
});

// Get all banboos
router.get('/', async (req, res) => {
    const query = `
        SELECT b.banbooId, b.name, b.price, b.description, b.level, b.imageUrl, b.createdAt, b.updatedAt,
               e.elementId, e.name AS elementName, e.elementIcon AS elementIcon, e.description AS elementDescription
        FROM banboos b
        LEFT JOIN elements e ON b.elementId = e.elementId;
    `;
    try {
        const results = await queryAsync(query);
        res.json(results);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Get a specific banboo by ID with element details
router.get('/:id', async (req, res) => {
    const { id } = req.params;
    const query = `
        SELECT b.banbooId, b.name, b.price, b.description, b.level, b.imageUrl, b.createdAt, b.updatedAt,
            e.elementId, e.name AS elementName, e.elementIcon AS elementIcon, e.description AS elementDescription
        FROM banboos b
        LEFT JOIN elements e ON b.elementId = e.elementId
        WHERE b.banbooId = ?;
    `;
    try {
        const results = await queryAsync(query, [id]);
        if (results.length === 0) return res.status(404).json({ error: 'Banboo not found' });
        res.json(results[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// adddmin add  banboo
router.post('/add', authenticateToken, isAdmin, async (req, res) => {
    const { name, price, description, elementId, level, imageUrl } = req.body;
    try {
        const result = await queryAsync('INSERT INTO banboos (name, price, description, elementId, level, imageUrl) VALUES (?, ?, ?, ?, ?, ?)', 
            [name, price, description, elementId, level, imageUrl]);
        res.status(201).json({ message: 'Banboo added successfully',  status: 'success' ,banbooId: result.insertId });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// adddmin update banboo
router.put('/update/:id', authenticateToken, isAdmin, async (req, res) => {
    const { id } = req.params;
    const { name, price, description, elementId, level, imageUrl } = req.body;
    try {
        await queryAsync('UPDATE banboos SET name = ?, price = ?, description = ?, elementId = ?, level = ?, imageUrl = ? WHERE banbooId = ?',
            [name, price, description, elementId, level, imageUrl, id]);
        res.json({ message: 'Banboo updated successfully', status: 'success' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Admin role can delete banboo
router.delete('/delete/:id', authenticateToken, isAdmin, async (req, res) => {
    const { id } = req.params;
    try {
        await queryAsync('DELETE FROM banboos WHERE banbooId = ?', [id]);
        res.json({ message: 'Banboo deleted successfully' });
    } catch (err) {

        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
