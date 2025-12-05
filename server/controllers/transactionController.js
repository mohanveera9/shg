const Transaction = require('../models/Transaction');
const Group = require('../models/Group');

const getTransactions = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { type, startDate, endDate, memberId } = req.query;
    
    const query = { groupId };
    
    if (type) {
      query.type = type;
    }
    
    if (startDate || endDate) {
      query.date = {};
      if (startDate) query.date.$gte = new Date(startDate);
      if (endDate) query.date.$lte = new Date(endDate);
    }
    
    if (memberId) {
      query.memberId = memberId;
    }
    
    const transactions = await Transaction.find(query)
      .populate('memberId', 'name phone')
      .populate('createdBy', 'name phone')
      .sort({ date: -1 });
    
    res.status(200).json({
      success: true,
      transactions
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching transactions', error: error.message });
  }
};

const createTransaction = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { type, amount, date, category, memberId, notes, receiptUrl } = req.body;
    const userId = req.user._id;
    
    if (!type || !amount || amount <= 0) {
      return res.status(400).json({ success: false, message: 'Type and valid amount are required' });
    }
    
    const group = await Group.findById(groupId);
    
    if (!group) {
      return res.status(404).json({ success: false, message: 'Group not found' });
    }
    
    const transaction = await Transaction.create({
      groupId,
      type,
      amount,
      date: date || new Date(),
      category: category || 'General',
      memberId: memberId || null,
      notes: notes || '',
      receiptUrl: receiptUrl || '',
      createdBy: userId
    });
    
    if (type === 'INCOME') {
      group.cashInHand += amount;
    } else if (type === 'EXPENSE') {
      group.cashInHand -= amount;
    } else if (type === 'SAVINGS') {
      group.totalSavings += amount;
      if (memberId) {
        const currentBalance = group.memberSavingsBalance.get(memberId.toString()) || 0;
        group.memberSavingsBalance.set(memberId.toString(), currentBalance + amount);
      }
    }
    
    await group.save();
    
    const populatedTransaction = await Transaction.findById(transaction._id)
      .populate('memberId', 'name phone')
      .populate('createdBy', 'name phone');
    
    res.status(201).json({
      success: true,
      message: 'Transaction created successfully',
      transaction: populatedTransaction,
      updatedBalances: {
        cashInHand: group.cashInHand,
        totalSavings: group.totalSavings
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error creating transaction', error: error.message });
  }
};

module.exports = {
  getTransactions,
  createTransaction
};
