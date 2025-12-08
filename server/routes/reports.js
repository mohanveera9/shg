const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const {
  getReports,
  exportReports,
} = require('../controllers/reportController');

router.get('/:groupId', authenticate, getReports);
router.post('/:groupId/export', authenticate, exportReports);

module.exports = router;
