const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { getDashboardData } = require('../controllers/dashboardController');

router.get('/:groupId', authenticate, getDashboardData);

module.exports = router;
