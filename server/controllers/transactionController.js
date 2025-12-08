const Transaction = require('../models/Transaction');
const Group = require('../models/Group');

const getTransactions = async (req, res) => {
  try {
    const { groupId } = req.params;
    const userId = req.userId;

    // Verify user is a member of the group
    const group = await Group.findById(groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const isMember = group.members.some(m => m.userId.toString() === userId);
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    const transactions = await Transaction.find({ groupId })
      .populate('userId', 'name phone')
      .sort({ date: -1, createdAt: -1 });

    res.json({
      success: true,
      transactions: transactions.map(transaction => ({
        id: transaction._id,
        groupId: transaction.groupId.toString(),
        userId: transaction.userId,
        createdBy: transaction.userId?._id?.toString() || transaction.userId?.toString() || '',
        type: transaction.type,
        amount: transaction.amount,
        category: transaction.category,
        description: transaction.description,
        notes: transaction.description, // Map description to notes for frontend
        memberName: transaction.memberName,
        memberId: transaction.userId?._id?.toString() || transaction.userId?.toString() || '',
        date: transaction.date,
        receiptUrl: transaction.receiptUrl || '',
        status: transaction.status,
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
      })),
    });
  } catch (error) {
    console.error('Error fetching transactions:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching transactions',
      error: error.message,
    });
  }
};

const createTransaction = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { type, amount, category, description, notes, memberName, date, receiptUrl } = req.body;
    const userId = req.userId;

    if (!type || !amount) {
      return res.status(400).json({
        success: false,
        message: 'Type and amount are required',
      });
    }

    const validTypes = ['INCOME', 'EXPENSE', 'SAVINGS', 'LOAN_REPAYMENT', 'LOAN_DISBURSAL'];
    if (!validTypes.includes(type)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid transaction type',
      });
    }

    // Verify user is a member of the group
    const group = await Group.findById(groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const isMember = group.members.some(m => m.userId.toString() === userId);
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    const transaction = new Transaction({
      groupId,
      userId,
      type,
      amount: parseFloat(amount),
      category: category || '',
      description: description || notes || '', // Accept both description and notes
      memberName: memberName || '',
      date: date ? new Date(date) : new Date(),
      receiptUrl: receiptUrl || null,
      status: 'COMPLETED',
    });

    await transaction.save();

    // Update group cash in hand based on transaction type
    if (type === 'INCOME' || type === 'LOAN_REPAYMENT') {
      group.cashInHand += parseFloat(amount);
    } else if (type === 'EXPENSE' || type === 'LOAN_DISBURSAL') {
      group.cashInHand -= parseFloat(amount);
    } else if (type === 'SAVINGS') {
      group.totalSavings += parseFloat(amount);
      group.cashInHand += parseFloat(amount);
    }

    await group.save();
    await transaction.populate('userId', 'name phone');

    res.status(201).json({
      success: true,
      message: 'Transaction created successfully',
      transaction: {
        id: transaction._id,
        groupId: transaction.groupId.toString(),
        userId: transaction.userId,
        createdBy: transaction.userId.toString(),
        type: transaction.type,
        amount: transaction.amount,
        category: transaction.category,
        description: transaction.description,
        notes: transaction.description, // Map description to notes for frontend
        memberName: transaction.memberName,
        memberId: transaction.userId.toString(),
        date: transaction.date,
        receiptUrl: transaction.receiptUrl || '',
        status: transaction.status,
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error creating transaction:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating transaction',
      error: error.message,
    });
  }
};

module.exports = {
  getTransactions,
  createTransaction,
};

