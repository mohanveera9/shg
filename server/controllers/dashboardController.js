const Transaction = require('../models/Transaction');
const Loan = require('../models/Loan');
const Group = require('../models/Group');

const getDashboardData = async (req, res) => {
  try {
    const { groupId } = req.params;

    const group = await Group.findById(groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const incomeTransactions = await Transaction.find({
      groupId,
      type: 'INCOME',
    }).select('amount');

    const expenseTransactions = await Transaction.find({
      groupId,
      type: 'EXPENSE',
    }).select('amount');

    const savingsTransactions = await Transaction.find({
      groupId,
      type: 'SAVINGS',
    }).select('amount');

    const totalIncome = incomeTransactions.reduce((sum, t) => sum + t.amount, 0);
    const totalExpense = expenseTransactions.reduce((sum, t) => sum + t.amount, 0);
    const groupSavings = savingsTransactions.reduce((sum, t) => sum + t.amount, 0);

    const dueLoans = await Loan.countDocuments({
      groupId,
      status: { $in: ['APPROVED', 'DISBURSED'] },
    });

    const todayTransactions = await Transaction.countDocuments({
      groupId,
      date: {
        $gte: new Date(new Date().setHours(0, 0, 0, 0)),
        $lt: new Date(new Date().setHours(23, 59, 59, 999)),
      },
    });

    res.json({
      success: true,
      data: {
        cashInHand: group.cashInHand,
        groupSavings,
        totalIncome,
        totalExpense,
        dueLoans,
        todayTasks: todayTransactions,
        totalMembers: group.totalMembers,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching dashboard data',
      error: error.message,
    });
  }
};

module.exports = {
  getDashboardData,
};
