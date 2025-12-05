const express = require('express');
const router = express.Router();
const { createOrder, getOrders, acceptOrder, fulfillOrder } = require('../controllers/orderController');
const { authenticate } = require('../middleware/auth');
const { checkRole } = require('../middleware/rbac');

router.post('/:groupId', authenticate, createOrder);
router.get('/:groupId', authenticate, getOrders);
router.put('/:orderId/accept', authenticate, acceptOrder);
router.put('/:orderId/fulfill', authenticate, fulfillOrder);

module.exports = router;
