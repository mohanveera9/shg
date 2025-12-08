const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { updateProfile } = require('../controllers/userController');

router.get('/profile', authenticate, (req, res) => {
  res.json({
    success: true,
    user: {
      id: req.user._id,
      phone: req.user.phone,
      name: req.user.name,
      email: req.user.email,
      profilePhoto: req.user.profilePhoto,
      role: req.user.role,
    },
  });
});

router.put('/profile', authenticate, updateProfile);

module.exports = router;
