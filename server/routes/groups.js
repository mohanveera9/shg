const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const {
  createGroup,
  joinGroup,
  getUserGroups,
  getGroupDetails,
  addMemberToGroup,
} = require('../controllers/groupController');

router.post('/create', authenticate, createGroup);
router.post('/join', authenticate, joinGroup);
router.post('/:groupId/add-member', authenticate, addMemberToGroup);
router.get('/my-groups', authenticate, getUserGroups);
router.get('/:groupId', authenticate, getGroupDetails);

module.exports = router;
