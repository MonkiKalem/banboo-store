const { queryAsync } = require("../util/queryAsync");


// Get all elements 
async function getAllElements(req, res) {  
  try {  
    await queryAsync('USE db_banboo');  

    const elements = await queryAsync(  
      `SELECT * FROM elements`  
    );  

    res.status(200).json({  
      message: 'Elements retrieved successfully',  
      elements: elements  
    });  

  } catch (error) {  
    console.error('Get All Elements Error:', error);  
    res.status(500).json({   
      message: 'Error retrieving elements',   
      error: error.message   
    });  
  }  
}  


module.exports = {
  getAllElements

}