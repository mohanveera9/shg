const Transaction = require('../models/Transaction');
const Loan = require('../models/Loan');
const Group = require('../models/Group');
const Product = require('../models/Product');
const Order = require('../models/Order');

const getReports = async (req, res) => {
  try {
    const { groupId } = req.params;
    let { startDate, endDate } = req.query;
    
    if (!startDate) {
      const now = new Date();
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
    } else {
      startDate = new Date(startDate);
    }
    
    if (!endDate) {
      endDate = new Date();
    } else {
      endDate = new Date(endDate);
    }
    
    const transactions = await Transaction.find({
      groupId,
      date: { $gte: startDate, $lte: endDate }
    });
    
    let income = 0;
    let expense = 0;
    
    transactions.forEach(t => {
      if (t.type === 'INCOME' || t.type === 'LOAN_REPAYMENT') {
        income += t.amount;
      } else if (t.type === 'EXPENSE' || t.type === 'LOAN_DISBURSAL') {
        expense += t.amount;
      }
    });
    
    const group = await Group.findById(groupId).populate('members.userId', 'name phone');
    
    const savingsByMember = group.members.map(member => ({
      memberId: member.userId._id,
      name: member.userId.name || member.userId.phone,
      amount: group.memberSavingsBalance.get(member.userId._id.toString()) || 0
    }));
    
    const loans = await Loan.find({
      groupId,
      status: { $in: ['DISBURSED', 'APPROVED'] }
    });
    
    const outstandingLoans = loans.reduce((sum, loan) => sum + (loan.remainingBalance || 0), 0);
    
    const products = await Product.find({ groupId, isActive: true });
    const productIds = products.map(p => p._id);
    
    const orderStats = await Order.aggregate([
      {
        $match: {
          groupId: group._id,
          productId: { $in: productIds },
          status: { $ne: 'CANCELLED' }
        }
      },
      {
        $group: {
          _id: '$productId',
          totalSales: { $sum: '$quantity' }
        }
      },
      {
        $sort: { totalSales: -1 }
      },
      {
        $limit: 5
      }
    ]);
    
    const topProducts = await Promise.all(
      orderStats.map(async (stat) => {
        const product = await Product.findById(stat._id);
        return {
          productId: stat._id,
          name: product.title,
          sales: stat.totalSales
        };
      })
    );
    
    res.status(200).json({
      success: true,
      period: { startDate, endDate },
      income,
      expense,
      savingsByMember,
      outstandingLoans,
      topProducts
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching reports', error: error.message });
  }
};

const exportReport = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { format, startDate, endDate } = req.body;
    
    res.status(200).json({
      success: true,
      message: 'Export functionality coming soon',
      downloadUrl: `dummy_export_${format}_${Date.now()}.${format.toLowerCase()}`
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error exporting report', error: error.message });
  }
};

module.exports = {
  getReports,
  exportReport
};
