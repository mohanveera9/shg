const express = require('express');
const router = express.Router();
const { requestLoan, approveLoan, disburseLoan, repayLoan, getLoans, getLoan } = require('../controllers/loanController');
const { authenticate } = require('../middleware/auth');
const { checkRole } = require('../middleware/rbac');

router.post('/:groupId/request', authenticate, checkRole(['MEMBER', 'TREASURER', 'PRESIDENT']), requestLoan);
router.put('/:loanId/approve', authenticate, approveLoan);
router.put('/:loanId/disburse', authenticate, disburseLoan);
router.post('/:loanId/repay', authenticate, repayLoan);
router.get('/:groupId', authenticate, getLoans);
router.get('/detail/:loanId', authenticate, getLoan);

module.exports = router;
