const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const {
  getProducts,
  getProductDetail,
  createProduct,
  updateProduct,
} = require('../controllers/productController');

router.get('/detail/:productId', authenticate, getProductDetail);
router.get('/:groupId', authenticate, getProducts);
router.post('/:groupId', authenticate, createProduct);
router.put('/:productId', authenticate, updateProduct);

module.exports = router;
