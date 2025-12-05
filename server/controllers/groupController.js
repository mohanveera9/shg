const Group = require('../models/Group');
const User = require('../models/User');
const { generateGroupCode } = require('../utils/helpers');

const createGroup = async (req, res) => {
  try {
    const { name, village, block, district, foundingMembers, researchConsent } = req.body;
    const userId = req.user._id;
    
    if (!name) {
      return res.status(400).json({ success: false, message: 'Group name is required' });
    }
    
    let groupCode;
    let isUnique = false;
    
    while (!isUnique) {
      groupCode = generateGroupCode();
      const existing = await Group.findOne({ groupCode });
      if (!existing) isUnique = true;
    }
    
    const members = [{
      userId: userId,
      role: 'PRESIDENT',
      joinedAt: new Date(),
      status: 'ACTIVE'
    }];
    
    if (foundingMembers && Array.isArray(foundingMembers)) {
      for (const phone of foundingMembers) {
        if (phone !== req.user.phone) {
          let member = await User.findOne({ phone });
          if (!member) {
            member = await User.create({ phone });
          }
          members.push({
            userId: member._id,
            role: 'MEMBER',
            joinedAt: new Date(),
            status: 'ACTIVE'
          });
        }
      }
    }
    
    const group = await Group.create({
      name,
      groupCode,
      village: village || '',
      block: block || '',
      district: district || '',
      createdBy: userId,
      members,
      researchConsent: researchConsent || false
    });
    
    await User.findByIdAndUpdate(userId, { 
      $addToSet: { groups: group._id } 
    });
    
    for (const member of members) {
      if (member.userId.toString() !== userId.toString()) {
        await User.findByIdAndUpdate(member.userId, { 
          $addToSet: { groups: group._id } 
        });
      }
    }
    
    const qrData = JSON.stringify({
      groupCode: group.groupCode,
      groupName: group.name
    });
    
    res.status(201).json({
      success: true,
      message: 'Group created successfully',
      group: {
        id: group._id,
        name: group.name,
        groupCode: group.groupCode,
        qrData,
        creatorRole: 'PRESIDENT',
        village: group.village,
        block: group.block,
        district: group.district,
        members: group.members
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error creating group', error: error.message });
  }
};

const joinGroup = async (req, res) => {
  try {
    const { groupCode } = req.body;
    const userId = req.user._id;
    
    if (!groupCode) {
      return res.status(400).json({ success: false, message: 'Group code is required' });
    }
    
    const group = await Group.findOne({ groupCode });
    
    if (!group) {
      return res.status(404).json({ success: false, message: 'Group not found' });
    }
    
    const existingMember = group.members.find(m => m.userId.toString() === userId.toString());
    
    if (existingMember) {
      return res.status(400).json({ success: false, message: 'Already a member of this group' });
    }
    
    group.members.push({
      userId: userId,
      role: 'MEMBER',
      joinedAt: new Date(),
      status: 'ACTIVE'
    });
    
    await group.save();
    
    await User.findByIdAndUpdate(userId, { 
      $addToSet: { groups: group._id } 
    });
    
    res.status(200).json({
      success: true,
      message: 'Joined group successfully',
      group: {
        id: group._id,
        name: group.name,
        village: group.village,
        block: group.block,
        district: group.district
      },
      membership: {
        role: 'MEMBER',
        status: 'ACTIVE'
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error joining group', error: error.message });
  }
};

const getGroup = async (req, res) => {
  try {
    const { groupId } = req.params;
    
    const group = await Group.findById(groupId)
      .populate('members.userId', 'name phone')
      .populate('createdBy', 'name phone');
    
    if (!group) {
      return res.status(404).json({ success: false, message: 'Group not found' });
    }
    
    res.status(200).json({
      success: true,
      group
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching group', error: error.message });
  }
};

const getUserGroups = async (req, res) => {
  try {
    const userId = req.user._id;
    
    const groups = await Group.find({ 'members.userId': userId })
      .select('name groupCode village block district members')
      .lean();
    
    const groupsWithRole = groups.map(group => {
      const member = group.members.find(m => m.userId.toString() === userId.toString());
      return {
        ...group,
        userRole: member ? member.role : 'MEMBER'
      };
    });
    
    res.status(200).json({
      success: true,
      groups: groupsWithRole
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching groups', error: error.message });
  }
};

module.exports = {
  createGroup,
  joinGroup,
  getGroup,
  getUserGroups
};
