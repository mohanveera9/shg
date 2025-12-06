const Group = require('../models/Group');
const User = require('../models/User');
const { generateGroupCode, generateGroupId, generateQRCode } = require('../utils/helpers');

const createGroup = async (req, res) => {
  try {
    const { name, village, block, district, foundingMembers, researchConsent } = req.body;
    const userId = req.userId;

    if (!name) {
      return res.status(400).json({
        success: false,
        message: 'Group name is required',
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
        researchConsent: group.researchConsent,
        cashInHand: group.cashInHand,
        totalSavings: group.totalSavings,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error creating group',
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
        researchConsent: group.researchConsent,
        cashInHand: group.cashInHand,
        totalSavings: group.totalSavings,
      },
    });
  } catch (error) {
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

    const user = await User.findById(userId).populate('groups.groupId');

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    const groupIds = user.groups.map(g => g.groupId._id);

    const groups = await Group.find({ _id: { $in: groupIds } });

    const groupsWithRole = groups.map(group => {
      const userGroup = user.groups.find(g => g.groupId._id.toString() === group._id.toString());
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
        members: group.members,
        totalMembers: group.totalMembers,
        researchConsent: group.researchConsent,
        cashInHand: group.cashInHand,
        totalSavings: group.totalSavings,
        userRole: userGroup?.role,
      };
    });

    res.json({
      success: true,
      groups: groupsWithRole,
    });
  } catch (error) {
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

    const group = await Group.findById(groupId);

    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

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
        members: group.members,
        totalMembers: group.totalMembers,
        researchConsent: group.researchConsent,
        cashInHand: group.cashInHand,
        totalSavings: group.totalSavings,
      },
    });
  } catch (error) {
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
};
