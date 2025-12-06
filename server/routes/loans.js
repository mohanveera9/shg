const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');

router.get('/:groupId', authenticate, (req, res) => {
  res.json({ success: true, loans: [] });
});

router.post('/:groupId/request', authenticate, (req, res) => {
  res.json({ success: true, message: 'Loan requested' });
});

router.put('/:loanId/approve', authenticate, (req, res) => {
  res.json({ success: true, message: 'Loan approved' });
});

router.put('/:loanId/disburse', authenticate, (req, res) => {
  res.json({ success: true, message: 'Loan disbursed' });
});

router.post('/:loanId/repay', authenticate, (req, res) => {
  res.json({ success: true, message: 'Repayment processed' });
});

module.exports = router;
