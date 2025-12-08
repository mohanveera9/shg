const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const {
  getLoans,
  requestLoan,
  approveLoan,
  disburseLoan,
  repayLoan,
} = require('../controllers/loanController');

router.get('/:groupId', authenticate, getLoans);
router.post('/:groupId/request', authenticate, requestLoan);
router.put('/:loanId/approve', authenticate, approveLoan);
router.put('/:loanId/disburse', authenticate, disburseLoan);
router.post('/:loanId/repay', authenticate, repayLoan);

module.exports = router;
