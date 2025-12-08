const Group = require('../models/Group');
const Transaction = require('../models/Transaction');
const Loan = require('../models/Loan');
const Order = require('../models/Order');
const Product = require('../models/Product');

const getReports = async (req, res) => {
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

    // Get date range from query params (default to last 30 days)
    const days = parseInt(req.query.days) || 30;
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);
    const endDate = new Date();

    // Financial Summary
    const incomeTransactions = await Transaction.find({
      groupId,
      type: 'INCOME',
      date: { $gte: startDate, $lte: endDate },
    });
    const expenseTransactions = await Transaction.find({
      groupId,
      type: 'EXPENSE',
      date: { $gte: startDate, $lte: endDate },
    });
    const savingsTransactions = await Transaction.find({
      groupId,
      type: 'SAVINGS',
      date: { $gte: startDate, $lte: endDate },
    });

    const totalIncome = incomeTransactions.reduce((sum, t) => sum + t.amount, 0);
    const totalExpense = expenseTransactions.reduce((sum, t) => sum + t.amount, 0);
    const totalSavings = savingsTransactions.reduce((sum, t) => sum + t.amount, 0);

    // Loan Summary
    const activeLoans = await Loan.countDocuments({
      groupId,
      status: { $in: ['APPROVED', 'DISBURSED'] },
    });
    const totalLoanAmount = await Loan.aggregate([
      { $match: { groupId: group._id, status: 'DISBURSED' } },
      { $group: { _id: null, total: { $sum: '$disbursedAmount' } } },
    ]);
    const totalLoanRepaid = await Transaction.aggregate([
      { $match: { groupId: group._id, type: 'LOAN_REPAYMENT', date: { $gte: startDate, $lte: endDate } } },
      { $group: { _id: null, total: { $sum: '$amount' } } },
    ]);

    // Order Summary
    const totalOrders = await Order.countDocuments({
      groupId,
      createdAt: { $gte: startDate, $lte: endDate },
    });
    const completedOrders = await Order.countDocuments({
      groupId,
      status: 'DELIVERED',
      createdAt: { $gte: startDate, $lte: endDate },
    });
    const orderRevenue = await Order.aggregate([
      { $match: { groupId: group._id, status: 'DELIVERED', createdAt: { $gte: startDate, $lte: endDate } } },
      { $group: { _id: null, total: { $sum: '$totalAmount' } } },
    ]);

    // Product Summary
    const totalProducts = await Product.countDocuments({ groupId });
    const lowStockProducts = await Product.countDocuments({
      groupId,
      stock: { $lt: 10 },
    });

    // Top Products by Sales
    const topProducts = await Order.aggregate([
      { $match: { groupId: group._id, status: 'DELIVERED', createdAt: { $gte: startDate, $lte: endDate } } },
      { $group: { _id: '$productId', totalSold: { $sum: '$quantity' }, totalRevenue: { $sum: '$totalAmount' } } },
      { $sort: { totalSold: -1 } },
      { $limit: 5 },
      {
        $lookup: {
          from: 'products',
          localField: '_id',
          foreignField: '_id',
          as: 'product',
        },
      },
      { $unwind: '$product' },
      {
        $project: {
          productId: '$_id',
          productName: '$product.title',
          totalSold: 1,
          totalRevenue: 1,
        },
      },
    ]);

    // Category-wise Expenses
    const categoryExpenses = await Transaction.aggregate([
      {
        $match: {
          groupId: group._id,
          type: 'EXPENSE',
          date: { $gte: startDate, $lte: endDate },
          category: { $ne: '' },
        },
      },
      { $group: { _id: '$category', total: { $sum: '$amount' } } },
      { $sort: { total: -1 } },
    ]);

    res.json({
      success: true,
      reports: {
        financial: {
          totalIncome,
          totalExpense,
          totalSavings,
          netProfit: totalIncome - totalExpense,
          cashInHand: group.cashInHand,
          groupSavings: group.totalSavings,
        },
        loans: {
          activeLoans,
          totalLoanAmount: totalLoanAmount[0]?.total || 0,
          totalLoanRepaid: totalLoanRepaid[0]?.total || 0,
          pendingLoanAmount: (totalLoanAmount[0]?.total || 0) - (totalLoanRepaid[0]?.total || 0),
        },
        orders: {
          totalOrders,
          completedOrders,
          pendingOrders: totalOrders - completedOrders,
          revenue: orderRevenue[0]?.total || 0,
        },
        products: {
          totalProducts,
          lowStockProducts,
          topProducts: topProducts.map(p => ({
            productId: p.productId,
            productName: p.productName,
            totalSold: p.totalSold,
            totalRevenue: p.totalRevenue,
          })),
        },
        categoryExpenses: categoryExpenses.map(c => ({
          category: c._id,
          total: c.total,
        })),
        period: {
          startDate,
          endDate,
          days,
        },
      },
    });
  } catch (error) {
    console.error('Error fetching reports:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching reports',
      error: error.message,
    });
  }
};

const exportReports = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { format = 'csv' } = req.body;
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

    // For now, return a placeholder URL
    // In a real implementation, you would generate the file and upload it to cloud storage
    const reportId = `report_${groupId}_${Date.now()}`;
    const downloadUrl = `${process.env.API_BASE_URL || 'http://localhost:3000'}/api/reports/download/${reportId}`;

    res.json({
      success: true,
      message: 'Report export initiated',
      downloadUrl,
      reportId,
      expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 hours
    });
  } catch (error) {
    console.error('Error exporting reports:', error);
    res.status(500).json({
      success: false,
      message: 'Error exporting reports',
      error: error.message,
    });
  }
};

module.exports = {
  getReports,
  exportReports,
};

