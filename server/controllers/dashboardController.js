const Group = require('../models/Group');
const Transaction = require('../models/Transaction');
const Loan = require('../models/Loan');
const Product = require('../models/Product');
const Order = require('../models/Order');

const getDashboard = async (req, res) => {
  try {
    const { groupId } = req.params;
    const userId = req.user._id;
    
    const group = await Group.findById(groupId);
    
    if (!group) {
      return res.status(404).json({ success: false, message: 'Group not found' });
    }
    
    const member = group.members.find(m => m.userId.toString() === userId.toString());
    const userRole = member ? member.role : 'MEMBER';
    
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const todayTransactions = await Transaction.countDocuments({
      groupId,
      date: { $gte: today }
    });
    
    const dueLoans = await Loan.countDocuments({
      groupId,
      status: 'DISBURSED',
      'schedule.paid': false,
      'schedule.dueDate': { $lte: new Date() }
    });
    
    const products = await Product.find({ groupId, isActive: true })
      .sort({ createdAt: -1 })
      .limit(1);
    
    const topProduct = products.length > 0 ? {
      name: products[0].title,
      sales: 0
    } : null;
    
    if (topProduct) {
      const orderCount = await Order.countDocuments({
        groupId,
        productId: products[0]._id,
        status: { $ne: 'CANCELLED' }
      });
      topProduct.sales = orderCount;
    }
    
    res.status(200).json({
      success: true,
      groupName: group.name,
      todayTasks: todayTransactions + dueLoans,
      cashInHand: group.cashInHand || 0,
      groupSavings: group.totalSavings || 0,
      dueLoans,
      topProduct,
      userRole
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching dashboard', error: error.message });
  }
};

module.exports = {
  getDashboard
};
