const Group = require('../models/Group');
const User = require('../models/User');
const { generateGroupCode, generateGroupId, generateQRCode } = require('../utils/helpers');

const createGroup = async (req, res) => {
  try {
    const { name, village, block, district, foundingMembers, researchConsent, expectedMemberCount } = req.body;
    const userId = req.userId;

    if (!name) {
      return res.status(400).json({
        success: false,
        message: 'Group name is required',
      });
    }

    // Check if user already has a group
    const user = await User.findById(userId);
    if (user && user.groups && user.groups.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'You can only be a member of one group. Please leave your current group first.',
      });
    }

    const groupCode = generateGroupCode();
    const groupId = generateGroupId();

    const group = new Group({
      name,
      groupCode,
      groupId,
      village: village || '',
      block: block || '',
      district: district || '',
      createdBy: userId,
      researchConsent: researchConsent || false,
      expectedMemberCount: expectedMemberCount || null,
      members: [{
        userId,
        role: 'PRESIDENT',
        status: 'ACTIVE',
      }],
      totalMembers: 1,
    });

    await group.save();

    const qrData = {
      groupCode: group.groupCode,
      groupId: group.groupId,
      groupName: group.name,
    };

    const qrCode = await generateQRCode(qrData);
    group.qrCode = qrCode;
    await group.save();

    await User.findByIdAndUpdate(
      userId,
      {
        $push: {
          groups: {
            groupId: group._id,
            role: 'PRESIDENT',
            status: 'ACTIVE',
          },
        },
      },
      { new: true }
    );

    res.status(201).json({
      success: true,
      message: 'Group created successfully',
      group: {
        id: group._id,
        name: group.name,
        groupCode: group.groupCode,
        groupId: group.groupId,
        qrCode: group.qrCode,
        village: group.village,
        block: group.block,
        district: group.district,
        createdBy: group.createdBy,
        members: group.members,
        totalMembers: group.totalMembers,
        expectedMemberCount: group.expectedMemberCount,
        researchConsent: group.researchConsent,
        cashInHand: group.cashInHand,
        totalSavings: group.totalSavings,
      },
    });
  } catch (error) {
    console.error('Error creating group:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating group',
      error: error.message,
    });
  }
};

const addMemberToGroup = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { memberPhone } = req.body;
    const userId = req.userId;

    if (!memberPhone) {
      return res.status(400).json({
        success: false,
        message: 'Member phone number is required',
      });
    }

    const group = await Group.findById(groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    // Check if requester is PRESIDENT or TREASURER
    const requesterMember = group.members.find(m => m.userId.toString() === userId);
    if (!requesterMember || (requesterMember.role !== 'PRESIDENT' && requesterMember.role !== 'TREASURER')) {
      return res.status(403).json({
        success: false,
        message: 'Only group president or treasurer can add members',
      });
    }

    // Find user by phone
    const memberUser = await User.findOne({ phone: memberPhone });
    if (!memberUser) {
      return res.status(404).json({
        success: false,
        message: 'User not found with this phone number',
      });
    }

    // Check if user is already a member
    const memberExists = group.members.some(m => m.userId.toString() === memberUser._id.toString());
    if (memberExists) {
      return res.status(400).json({
        success: false,
        message: 'User is already a member of this group',
      });
    }

    // Add member to group
    group.members.push({
      userId: memberUser._id,
      role: 'MEMBER',
      status: 'ACTIVE',
    });
    group.totalMembers += 1;
    await group.save();

    // Add group to user's groups
    await User.findByIdAndUpdate(
      memberUser._id,
      {
        $push: {
          groups: {
            groupId: group._id,
            role: 'MEMBER',
            status: 'ACTIVE',
          },
        },
      },
      { new: true }
    );

    res.json({
      success: true,
      message: 'Member added successfully',
      group: {
        id: group._id,
        name: group.name,
        groupCode: group.groupCode,
        totalMembers: group.totalMembers,
        members: group.members,
      },
    });
  } catch (error) {
    console.error('Error adding member:', error);
    res.status(500).json({
      success: false,
      message: 'Error adding member',
      error: error.message,
    });
  }
};

const joinGroup = async (req, res) => {
  try {
    const { groupCode } = req.body;
    const userId = req.userId;

    if (!groupCode) {
      return res.status(400).json({
        success: false,
        message: 'Group code is required',
      });
    }

    // Check if user already has a group
    const user = await User.findById(userId);
    if (user && user.groups && user.groups.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'You can only be a member of one group. Please leave your current group first.',
      });
    }

    const group = await Group.findOne({ groupCode: groupCode.toUpperCase() });

    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const memberExists = group.members.some(m => m.userId.toString() === userId);
    if (memberExists) {
      return res.status(400).json({
        success: false,
        message: 'You are already a member of this group',
      });
    }

    group.members.push({
      userId,
      role: 'MEMBER',
      status: 'ACTIVE',
    });
    group.totalMembers += 1;
    await group.save();

    await User.findByIdAndUpdate(
      userId,
      {
        $push: {
          groups: {
            groupId: group._id,
            role: 'MEMBER',
            status: 'ACTIVE',
          },
        },
      },
      { new: true }
    );

    res.json({
      success: true,
      message: 'Joined group successfully',
      group: {
        id: group._id,
        name: group.name,
        groupCode: group.groupCode,
        groupId: group.groupId,
        qrCode: group.qrCode,
        village: group.village,
        block: group.block,
        district: group.district,
        createdBy: group.createdBy,
        members: group.members,
        totalMembers: group.totalMembers,
        expectedMemberCount: group.expectedMemberCount,
        researchConsent: group.researchConsent,
        cashInHand: group.cashInHand,
        totalSavings: group.totalSavings,
      },
    });
  } catch (error) {
    console.error('Error joining group:', error);
    res.status(500).json({
      success: false,
      message: 'Error joining group',
      error: error.message,
    });
  }
};

const getUserGroups = async (req, res) => {
  try {
    const userId = req.userId;

    // Find all groups where the user is a member
    const groups = await Group.find({
      'members.userId': userId,
      'members.status': 'ACTIVE' // Only get active memberships
    }).populate('members.userId', 'name phone');

    if (!groups || groups.length === 0) {
      return res.json({
        success: true,
        groups: [],
      });
    }

    // Map groups with user's role in each group
    const groupsWithRole = groups.map(group => {
      const member = group.members.find(m => m.userId.toString() === userId);
      return {
        id: group._id,
        name: group.name,
        groupCode: group.groupCode,
        groupId: group.groupId,
        qrCode: group.qrCode,
        village: group.village,
        block: group.block,
        district: group.district,
        createdBy: group.createdBy,
        members: group.members.map(m => ({
          userId: m.userId?._id?.toString() || m.userId?.toString() || '',
          userName: m.userId?.name || 'Unknown',
          userPhone: m.userId?.phone || '',
          role: m.role,
          joinedAt: m.joinedAt,
          status: m.status,
        })),
        totalMembers: group.totalMembers,
        expectedMemberCount: group.expectedMemberCount,
        researchConsent: group.researchConsent,
        cashInHand: group.cashInHand,
        totalSavings: group.totalSavings,
        userRole: member?.role || 'MEMBER',
        joinedAt: member?.joinedAt,
      };
    });

    res.json({
      success: true,
      groups: groupsWithRole,
    });
  } catch (error) {
    console.error('Error fetching groups:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching groups',
      error: error.message,
    });
  }
};

const getGroupDetails = async (req, res) => {
  try {
    const { groupId } = req.params;
    const userId = req.userId;

    const group = await Group.findById(groupId)
      .populate('members.userId', 'name phone');

    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    // Check if user is a member of this group
    const isMember = group.members.some(m => m.userId.toString() === userId);
    
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    // Get user's role in the group
    const member = group.members.find(m => m.userId.toString() === userId);

    res.json({
      success: true,
      group: {
        id: group._id,
        name: group.name,
        groupCode: group.groupCode,
        groupId: group.groupId,
        qrCode: group.qrCode,
        village: group.village,
        block: group.block,
        district: group.district,
        createdBy: group.createdBy,
        members: group.members.map(m => ({
          userId: m.userId?._id?.toString() || m.userId?.toString() || '',
          userName: m.userId?.name || 'Unknown',
          userPhone: m.userId?.phone || '',
          role: m.role,
          joinedAt: m.joinedAt,
          status: m.status,
        })),
        totalMembers: group.totalMembers,
        expectedMemberCount: group.expectedMemberCount,
        researchConsent: group.researchConsent,
        cashInHand: group.cashInHand,
        totalSavings: group.totalSavings,
        userRole: member?.role,
      },
    });
  } catch (error) {
    console.error('Error fetching group details:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching group details',
      error: error.message,
    });
  }
};

module.exports = {
  createGroup,
  joinGroup,
  getUserGroups,
  getGroupDetails,
  addMemberToGroup,
};