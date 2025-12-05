const express = require('express');
const router = express.Router();
const { getReports, exportReport } = require('../controllers/reportController');
const { authenticate } = require('../middleware/auth');

router.get('/:groupId', authenticate, getReports);
router.post('/:groupId/export', authenticate, exportReport);

module.exports = router;
