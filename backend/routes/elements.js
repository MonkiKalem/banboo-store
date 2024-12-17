const express = require('express');
const router = express.Router();
const { getAllElements } = require('../controller/elementController');

// get all elements
router.get('/', getAllElements); 

module.exports = router;