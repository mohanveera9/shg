const express = require('express');
const router = express.Router();
const { createProduct, getProducts, getProduct, updateProduct } = require('../controllers/productController');
const { authenticate } = require('../middleware/auth');
const { checkRole } = require('../middleware/rbac');

router.post('/:groupId', authenticate, checkRole(['MEMBER', 'TREASURER', 'PRESIDENT']), createProduct);
router.get('/:groupId', authenticate, getProducts);
router.get('/detail/:productId', authenticate, getProduct);
router.put('/:productId', authenticate, updateProduct);

module.exports = router;
