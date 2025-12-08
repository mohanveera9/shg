const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const {
  getTransactions,
  createTransaction,
} = require('../controllers/transactionController');

router.get('/:groupId', authenticate, getTransactions);
router.post('/:groupId', authenticate, createTransaction);

module.exports = router;
