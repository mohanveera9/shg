const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');

router.get('/:groupId', authenticate, (req, res) => {
  res.json({ success: true, transactions: [] });
});

router.post('/:groupId', authenticate, (req, res) => {
  res.json({ success: true, message: 'Transaction created' });
});

module.exports = router;
