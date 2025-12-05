const express = require('express');
const router = express.Router();
const { createGroup, joinGroup, getGroup, getUserGroups } = require('../controllers/groupController');
const { authenticate } = require('../middleware/auth');

router.post('/create', authenticate, createGroup);
router.post('/join', authenticate, joinGroup);
router.get('/my-groups', authenticate, getUserGroups);
router.get('/:groupId', authenticate, getGroup);

module.exports = router;
