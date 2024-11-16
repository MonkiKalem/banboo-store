const bcrypt = require('bcrypt');
const connection = require('./database/connect'); // Adjust path if needed

const updatePasswords = async () => {
    connection.query('SELECT userId, password FROM users', async (err, users) => {
        if (err) {
            console.error('Error fetching users:', err.message);
            return;
        }

        for (const user of users) {
            const hashedPassword = await bcrypt.hash(user.password, 10);
            connection.query(
                'UPDATE users SET password = ? WHERE userId = ?',
                [hashedPassword, user.userId],
                (err) => {
                    if (err) {
                        console.error(
                            `Error updating password for userId ${user.userId}:`,
                            err.message
                        );
                    } else {
                        console.log(`Password updated for userId ${user.userId}`);
                    }
                }
            );
        }

        console.log('Password hashing completed.');
        connection.end();
    });
};

updatePasswords();
