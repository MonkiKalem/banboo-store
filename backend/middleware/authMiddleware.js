const jwt = require('jsonwebtoken');
const SECRET_KEY = process.env.JWT_SECRET || 'my_secret_key'; // Use environment variable or fallback

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'Unauthorized: No token provided' });
    }

    jwt.verify(token, SECRET_KEY, (err, user) => {
        if (err) {
            return res.status(403).json({ message: 'Forbidden: Invalid token' });
        }

        req.user = user;
        console.log('Decoded User:', req.user);
        next();
    });
};

const isAdmin = (req, res, next) => {
    console.log('User Role:', req.user.role); 
    if (req.user.role !== 'admin') {
        return res.status(403).json({ message: 'Forbidden: Admins only' });
    }
    next();
};

module.exports = { authenticateToken, isAdmin };
