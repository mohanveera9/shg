const express = require('express');
const router = express.Router();
const { getTransactions, createTransaction } = require('../controllers/transactionController');
const { authenticate } = require('../middleware/auth');
const { checkRole } = require('../middleware/rbac');

router.get('/:groupId', authenticate, getTransactions);
router.post('/:groupId', authenticate, checkRole(['MEMBER', 'TREASURER', 'PRESIDENT']), createTransaction);

module.exports = router;
