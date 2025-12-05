const Transaction = require('../models/Transaction');
const Group = require('../models/Group');

const addSavings = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { memberId, amount, date } = req.body;
    const userId = req.user._id;
    
    if (!memberId || !amount || amount <= 0) {
      return res.status(400).json({ success: false, message: 'Member and valid amount are required' });
    }
    
    const group = await Group.findById(groupId);
    
    if (!group) {
      return res.status(404).json({ success: false, message: 'Group not found' });
    }
    
    const transaction = await Transaction.create({
      groupId,
      type: 'SAVINGS',
      amount,
      date: date || new Date(),
      category: 'Savings',
      memberId,
      createdBy: userId
    });
    
    group.totalSavings += amount;
    const currentBalance = group.memberSavingsBalance.get(memberId.toString()) || 0;
    group.memberSavingsBalance.set(memberId.toString(), currentBalance + amount);
    
    await group.save();
    
    const memberSavings = group.memberSavingsBalance.get(memberId.toString());
    
    res.status(201).json({
      success: true,
      message: 'Savings added successfully',
      transaction,
      memberSavings,
      groupTotalSavings: group.totalSavings
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error adding savings', error: error.message });
  }
};

const getSavings = async (req, res) => {
  try {
    const { groupId } = req.params;
    
    const group = await Group.findById(groupId).populate('members.userId', 'name phone');
    
    if (!group) {
      return res.status(404).json({ success: false, message: 'Group not found' });
    }
    
    const savingsByMember = group.members.map(member => ({
      memberId: member.userId._id,
      memberName: member.userId.name || member.userId.phone,
      memberPhone: member.userId.phone,
      amount: group.memberSavingsBalance.get(member.userId._id.toString()) || 0
    }));
    
    res.status(200).json({
      success: true,
      savingsByMember,
      groupTotalSavings: group.totalSavings
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching savings', error: error.message });
  }
};

module.exports = {
  addSavings,
  getSavings
};
