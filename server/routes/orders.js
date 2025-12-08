const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const {
  getOrders,
  getOrderDetail,
  createOrder,
  acceptOrder,
  fulfillOrder,
} = require('../controllers/orderController');

router.get('/detail/:orderId', authenticate, getOrderDetail);
router.get('/:groupId', authenticate, getOrders);
router.post('/:groupId', authenticate, createOrder);
router.put('/:orderId/accept', authenticate, acceptOrder);
router.put('/:orderId/fulfill', authenticate, fulfillOrder);

module.exports = router;
