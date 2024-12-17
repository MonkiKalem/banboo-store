const express = require('express');  
const router = express.Router();  
const connection = require('../database/connect');  
const { authenticateToken } = require('../middleware/authMiddleware');  

// Utility function to promisify connection.query  
const queryAsync = (query, params = []) => {  
  return new Promise((resolve, reject) => {  
    connection.query(query, params, (err, results) => {  
      if (err) return reject(err);  
      resolve(results);  
    });  
  });  
};  

router.use(async (req, res, next) => {
  await queryAsync('USE db_banboo');
  next();
});

// Fungsi untuk mendapatkan atau membuat cart aktif  
const getOrCreateActiveCart = async (userId) => {  
  try {  
    // Cari cart aktif yang sudah ada  
    const existingCartQuery = `  
      SELECT cartId, totalPrice   
      FROM carts   
      WHERE userId = ? AND status = 'active'  
    `;  
    const existingCarts = await queryAsync(existingCartQuery, [userId]);  

    if (existingCarts.length > 0) {  
      return existingCarts[0];  
    }  

    // Buat cart baru jika tidak ada  
    const createCartQuery = `  
      INSERT INTO carts (userId, totalPrice, status)   
      VALUES (?, 0, 'active')  
    `;  
    const result = await queryAsync(createCartQuery, [userId]);  
    
    return {  
      cartId: result.insertId,  
      totalPrice: 0  
    };  
  } catch (error) {  
    throw error;  
  }  
};  

// Mendapatkan Cart User  
router.get('/', authenticateToken, async (req, res) => {  
  try {  
    const userId = req.user.userId;  

    const cartQuery = `  
      SELECT   
        c.cartId,  
        c.totalPrice,  
        ci.cartItemId,  
        b.banbooId,   
        b.name,   
        b.imageUrl,   
        ci.price as itemPrice,   
        ci.quantity,  
        e.name as elementName  
      FROM carts c  
      LEFT JOIN cart_items ci ON c.cartId = ci.cartId  
      LEFT JOIN banboos b ON ci.banbooId = b.banbooId  
      LEFT JOIN elements e ON b.elementId = e.elementId  
      WHERE c.userId = ? AND c.status = 'active'  
    `;  
    
    const cartItems = await queryAsync(cartQuery, [userId]);  

    // Jika cart kosong, kembalikan cart kosong  
    if (cartItems.length === 0 || cartItems[0].banbooId === null) {  
      return res.json({  
        cartId: null,  
        items: [],  
        totalPrice: 0,  
        totalItems: 0  
      });  
    }  

    // Transformasi hasil query  
    const transformedCart = {  
      cartId: cartItems[0].cartId,  
      totalPrice: cartItems[0].totalPrice,  
      items: cartItems.map(item => ({  
        cartItemId: item.cartItemId,  
        banbooId: item.banbooId,  
        name: item.name,  
        imageUrl: item.imageUrl,  
        price: item.itemPrice,  
        quantity: item.quantity,  
        elementName: item.elementName  
      })),  
      totalItems: cartItems.reduce((total, item) => total + item.quantity, 0)  
    };  

    res.json(transformedCart);  
  } catch (error) {  
    console.error('Cart Fetch Error:', error);  
    res.status(500).json({   
      message: 'Error fetching cart',   
      error: error.message   
    });  
  }  
});  

// Menambahkan Item ke Cart  
router.post('/add', authenticateToken, async (req, res) => {  
  const { banbooId, quantity = 1 } = req.body;  
  const userId = req.user.userId;  
  console.log(req.body); 
  if (!banbooId || quantity < 1) {  
    return res.status(400).json({ message: 'Invalid banboo or quantity' });  
  }  

  try {  

    // Dapatkan atau buat cart aktif  
    const cart = await getOrCreateActiveCart(userId);  

    // Cek apakah banboo valid dan dapatkan harganya  
    const banbooQuery = `  
      SELECT banbooId, price   
      FROM banboos   
      WHERE banbooId = ?  
    `;  
    const banboos = await queryAsync(banbooQuery, [banbooId]);  

    if (banboos.length === 0) {  
      throw new Error('Banboo not found');  
    }  

    const banbooPrice = banboos[0].price;  

    // Cek apakah item sudah ada di cart  
    const existingItemQuery = `  
      SELECT cartItemId, quantity AS existingQuantity   
      FROM cart_items   
      WHERE cartId = ? AND banbooId = ?  
    `;  
    const existingItems = await queryAsync(existingItemQuery, [cart.cartId, banbooId]);  

    if (existingItems.length > 0) {  
      // Update quantity dan harga  
      const newQuantity = existingItems[0].existingQuantity + quantity;  
      const updateItemQuery = `  
        UPDATE cart_items   
        SET quantity = ?, price = ?   
        WHERE cartItemId = ?  
      `;  
      await queryAsync(updateItemQuery, [  
        newQuantity,   
        banbooPrice * newQuantity,   
        existingItems[0].cartItemId  
      ]);  

      // Update total harga cart  
      const updateCartQuery = `  
        UPDATE carts   
        SET totalPrice = (  
          SELECT SUM(price)   
          FROM cart_items   
          WHERE cartId = ?  
        )   
        WHERE cartId = ?  
      `;  
      await queryAsync(updateCartQuery, [cart.cartId, cart.cartId]);  
    } else {  
      // Tambah item baru ke cart  
      const insertItemQuery = `  
        INSERT INTO cart_items (cartId, banbooId, quantity, price)   
        VALUES (?, ?, ?, ?)  
      `;  
      await queryAsync(insertItemQuery, [  
        cart.cartId,   
        banbooId,   
        quantity,   
        banbooPrice * quantity  
      ]);  

      // Update total harga cart  
      const updateCartQuery = `  
        UPDATE carts   
        SET totalPrice = totalPrice + ?   
        WHERE cartId = ?  
      `;  
      await queryAsync(updateCartQuery, [  
        banbooPrice * quantity,   
        cart.cartId  
      ]);  
    }  

    res.status(200).json({   
      message: 'Item added to cart successfully'  
    });  
  } catch (error) {  
    console.error('Add to Cart Error:', error);  
    res.status(500).json({   
      message: 'Error adding to cart',   
      error: error.message   
    });  
  }   
});  

// Update quantity Item dari Cart
router.put('/update/:cartItemId', authenticateToken, async (req, res) => {
  const { cartItemId } = req.params;
  const { quantity } = req.body; // Ambil quantity dari body request
  const userId = req.user.userId;

  if (!quantity || quantity < 1) {
    return res.status(400).json({ message: 'Invalid quantity' });
  }

  try {
    // Dapatkan harga banboo
    const banbooPriceQuery = `
      SELECT b.price
      FROM cart_items ci
      JOIN banboos b ON ci.banbooId = b.banbooId
      WHERE ci.cartItemId = ?
    `;
    const banbooResult = await queryAsync(banbooPriceQuery, [cartItemId]);
    if (banbooResult.length === 0) {
      return res.status(404).json({ message: 'Banboo not found' });
    }
    const banbooPrice = banbooResult[0].price;

    // Update quantity dan harga item dalam cart
    const updateItemQuery = `
      UPDATE cart_items ci
      JOIN carts c ON ci.cartId = c.cartId
      SET quantity = ?, price = ?
      WHERE ci.cartItemId = ? AND c.userId = ?
    `;
    await queryAsync(updateItemQuery, [
      quantity,
      banbooPrice * quantity,
      cartItemId,
      userId
    ]);

    // Update total harga cart
    const updateCartQuery = `
      UPDATE carts
      SET totalPrice = (
        SELECT SUM(price)
        FROM cart_items
        WHERE cartId = (
          SELECT cartId
          FROM cart_items
          WHERE cartItemId = ?
        )
      )
      WHERE cartId = (
        SELECT cartId
        FROM cart_items
        WHERE cartItemId = ?
      )
    `;
    await queryAsync(updateCartQuery, [cartItemId, cartItemId]);

    res.json({ message: 'Quantity and price updated successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


// Menghapus Item dari Cart  
router.delete('/remove/:cartItemId', authenticateToken, async (req, res) => {  
  const { cartItemId } = req.params;  
  const userId = req.user.userId;  

  try {  

    // Cek apakah cart item milik user  
    const checkOwnershipQuery = `  
      SELECT ci.cartItemId, ci.cartId, ci.price  
      FROM cart_items ci  
      JOIN carts c ON ci.cartId = c.cartId  
      WHERE ci.cartItemId = ? AND c.userId = ?  
    `;  
    const cartItems = await queryAsync(checkOwnershipQuery, [cartItemId, userId]);  

    if (cartItems.length === 0) {  
      throw new Error('Cart item not found');  
    }  

    const cartItem = cartItems[0];  

    // Hapus item dari cart  
    const deleteQuery = `  
      DELETE FROM cart_items   
      WHERE cartItemId = ?  
    `;  
    await queryAsync(deleteQuery, [cartItemId]);  

    // Update total harga cart  
    const updateCartQuery = `  
      UPDATE carts   
      SET totalPrice = (  
        SELECT COALESCE(SUM(price), 0)   
        FROM cart_items   
        WHERE cartId = ?  
      )   
      WHERE cartId = ?  
    `;  
    await queryAsync(updateCartQuery, [cartItem.cartId, cartItem.cartId]);  

    res.status(200).json({ message: 'Item removed from cart successfully' });  
  } catch (error) {  
    console.error('Remove from Cart Error:', error);  
    res.status(500).json({   
      message: 'Error removing from cart',   
      error: error.message   
    });  
  }  
});  

// Checkout Cart  
router.post('/checkout', authenticateToken, async (req, res) => {  
  const userId = req.user.userId;  

  try {  
    const cartQuery = `  
      SELECT   
        c.cartId,   
        c.totalPrice,   
        c.status,  
        c.userId  
      FROM carts c  
      WHERE c.userId = ? AND c.status = 'active'  
    `;  
    const carts = await queryAsync(cartQuery, [userId]);  

    if (carts.length === 0) {  
      return res.status(400).json({ message: 'No active cart found' });  
    }  

    const cart = carts[0];  

    const cartItemsQuery = `  
      SELECT   
        ci.cartItemId,  
        ci.cartId,  
        ci.banbooId,  
        ci.quantity,  
        ci.price
      FROM cart_items ci  
      WHERE ci.cartId = ?  
    `;  
    const cartItems = await queryAsync(cartItemsQuery, [cart.cartId]);  

    if (cartItems.length === 0) {  
      return res.status(400).json({ message: 'Cart is empty' });  
    }  

    await queryAsync('START TRANSACTION');  

    const createOrderQuery = `  
      INSERT INTO orders (  
        userId,   
        totalPrice  
      ) VALUES (?, ?)  
    `;  
    const orderResult = await queryAsync(createOrderQuery, [  
      userId,   
      cart.totalPrice,   
    ]);  
    const orderId = orderResult.insertId;  

    // Masukkan item-item ke order_items dengan semua detail  
    const insertOrderItemsQuery = `  
      INSERT INTO order_items (  
        orderId,    
        banbooId,   
        quantity,   
        price   
      ) VALUES ?  
    `;  
    const orderItemsValues = cartItems.map(item => [  
      orderId,  
      item.banbooId,   
      item.quantity,   
      item.price
    ]);  
    await queryAsync(insertOrderItemsQuery, [orderItemsValues]);  

 
    const clearCartItemsQuery = `  
      DELETE FROM cart_items  
      WHERE cartId = ?  
    `;  
    await queryAsync(clearCartItemsQuery, [cart.cartId]);  

    const deleteCartQuery = `  
      DELETE FROM carts  
      WHERE cartId = ?  
    `;  
    await queryAsync(deleteCartQuery, [cart.cartId]);  

    await queryAsync('COMMIT');  

    res.status(200).json({   
      message: 'Checkout successful',   
      orderId: orderId,
    });  

  } catch (error) {  
    await queryAsync('ROLLBACK');  
    
    console.error('Checkout Error:', error);  
    res.status(500).json({   
      message: 'Error during checkout',  
      error: error.message   
    });  
  }  
});

// Route untuk mendapatkan riwayat order dengan detail lengkap  
router.get('/orders', authenticateToken, async (req, res) => {  
  const userId = req.user.userId;  

  try {  
    const ordersQuery = `  
      SELECT   
        o.orderId,   
        o.totalPrice,   
        o.createdAt,  
        GROUP_CONCAT(  
          JSON_OBJECT(  
            'orderItemId', oi.orderItemId,  
            'banbooId', oi.banbooId,  
            'banbooName', b.name,
            'quantity', oi.quantity,  
            'price', oi.price,
            'banbooPrice', b.price,
            'imageUrl', b.imageUrl
          )  
        ) as items  
      FROM orders o  
      JOIN order_items oi ON o.orderId = oi.orderId  
      JOIN banboos b ON oi.banbooId = b.banbooId  
      WHERE o.userId = ?  
      GROUP BY o.orderId  
      ORDER BY o.createdAt DESC  
    `;  

    const orders = await queryAsync(ordersQuery, [userId]);  

    const parsedOrders = orders.map(order => ({  
      ...order,  
      items: JSON.parse(`[${order.items}]`)  
    }));  

    res.json(parsedOrders);  
  } catch (error) {  
    console.error('Get Orders Error:', error);  
    res.status(500).json({   
      message: 'Error fetching orders',  
      error: error.message   
    });  
  }  
});



module.exports = router;