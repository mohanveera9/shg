const express = require('express');
const router = express.Router();
const { addSavings, getSavings } = require('../controllers/savingsController');
const { authenticate } = require('../middleware/auth');
const { checkRole } = require('../middleware/rbac');

router.get('/:groupId', authenticate, getSavings);
router.post('/:groupId', authenticate, checkRole(['TREASURER', 'PRESIDENT']), addSavings);

module.exports = router;
