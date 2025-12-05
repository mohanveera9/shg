const express = require('express');
const router = express.Router();
const { sendOTP, verifyOTP, logout } = require('../controllers/authController');
const { authenticate } = require('../middleware/auth');

router.post('/send-otp', sendOTP);
router.post('/verify-otp', verifyOTP);
router.post('/logout', authenticate, logout);

module.exports = router;
