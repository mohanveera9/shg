const Group = require('../models/Group');

const checkRole = (allowedRoles) => {
  return async (req, res, next) => {
    try {
      const { groupId } = req.params;
      const userId = req.user._id;
      
      const group = await Group.findById(groupId);
      
      if (!group) {
        return res.status(404).json({ success: false, message: 'Group not found' });
      }
      
      const member = group.members.find(m => m.userId.toString() === userId.toString());
      
      if (!member) {
        return res.status(403).json({ success: false, message: 'Not a member of this group' });
      }
      
      if (member.status !== 'ACTIVE') {
        return res.status(403).json({ success: false, message: 'Member not active' });
      }
      
      if (allowedRoles.includes(member.role) || req.user.role === 'ADMIN' || req.user.role === 'FIELD_OFFICER') {
        req.memberRole = member.role;
        req.group = group;
        next();
      } else {
        return res.status(403).json({ success: false, message: 'Insufficient permissions' });
      }
    } catch (error) {
      return res.status(500).json({ success: false, message: 'Authorization error', error: error.message });
    }
  };
};

module.exports = { checkRole };
