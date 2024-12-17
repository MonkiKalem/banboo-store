const { queryAsync } = require("../util/queryAsync")


async function getUserById(req, res) {  
  const { userId } = req.params;

  try {  
    await queryAsync('USE db_banboo');  

    const [user] = await queryAsync(  
      `SELECT   
        userId,   
        name,   
        email,   
        role,   
        profile_picture,   
        created_at,   
        is_google_user   
      FROM users   
      WHERE userId = ?`,   
      [userId]  
    );  

    if (!user) {  
      return res.status(404).json({   
        message: 'User not found'   
      });  
    }  

    delete user.password;  

    res.status(200).json({  
      message: 'User retrieved successfully',  
      user: user  
    });  

  } catch (error) {  
    console.error('Get User Error:', error);  
    res.status(500).json({   
      message: 'Error retrieving user',   
      error: error.message   
    });  
  }  
}  


async function getAllUsers(req, res) {  
  try {  
    await queryAsync('USE db_banboo');  

    const users = await queryAsync(  
      `SELECT   
        userId,   
        name,   
        email,   
        role,   
        profile_picture,   
        created_at   
      FROM users`  
    );  

    res.status(200).json({  
      message: 'Users retrieved successfully',  
      users: users  
    });  

  } catch (error) {  
    console.error('Get All Users Error:', error);  
    res.status(500).json({   
      message: 'Error retrieving users',   
      error: error.message   
    });  
  }  
}  

async function updateProfile (req, res) {  
  const { userId } = req.user;
  const { name, email, profilePicture } = req.body;  
  
  try {  
    await queryAsync('USE db_banboo');  

    let updateQuery = 'UPDATE users SET ';  
    const updateParams = [];  
    
    if (name) {  
      updateQuery += 'name = ?, ';  
      updateParams.push(name);  
    }  
    
    if (email) {  
      updateQuery += 'email = ?, ';  
      updateParams.push(email);  
    }  

    if (profilePicture) {  
      updateQuery += 'profile_picture = ?, ';  
      updateParams.push(profilePicture);  
    }  

    updateQuery = updateQuery.slice(0, -2);  
    
    updateQuery += ' WHERE userId = ?';  
    updateParams.push(userId);  

    await queryAsync(updateQuery, updateParams);  

    const [updatedUser] = await queryAsync(  
      'SELECT userId, name, email, profile_picture, role FROM users WHERE userId = ?',   
      [userId]  
    );  

    res.status(200).json({  
      message: 'Profile updated successfully',  
      user: updatedUser  
    });  

  } catch (error) {  
    console.error('Profile update error:', error);  
    res.status(500).json({   
      message: 'Error updating profile',   
      error: error.message   
    });  
  }  
};

module.exports = {
  getUserById,
  getAllUsers,
  updateProfile
}