const Order = require('../models/Order');
const Product = require('../models/Product');
const Transaction = require('../models/Transaction');
const Group = require('../models/Group');

const createOrder = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { productId, quantity, buyerContact, buyerName, paymentMethod } = req.body;
    const userId = req.user._id;
    
    if (!productId || !quantity || quantity < 1) {
      return res.status(400).json({ success: false, message: 'Product and valid quantity are required' });
    }
    
    const product = await Product.findById(productId);
    
    if (!product) {
      return res.status(404).json({ success: false, message: 'Product not found' });
    }
    
    if (product.stock < quantity) {
      return res.status(400).json({ success: false, message: 'Insufficient stock' });
    }
    
    const totalAmount = product.price * quantity;
    
    const order = await Order.create({
      groupId,
      productId,
      quantity,
      buyerContact: buyerContact || '',
      buyerName: buyerName || '',
      totalAmount,
      paymentMethod: paymentMethod || 'DUMMY_UPI',
      status: 'PENDING',
      paymentStatus: 'PENDING',
      createdBy: userId
    });
    
    product.stock -= quantity;
    await product.save();
    
    res.status(201).json({
      success: true,
      message: 'Order created successfully',
      order
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error creating order', error: error.message });
  }
};

const getOrders = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { status } = req.query;
    
    const query = { groupId };
    
    if (status) {
      query.status = status;
    }
    
    const orders = await Order.find(query)
      .populate('productId', 'title price photoUrl')
      .populate('createdBy', 'name phone')
      .sort({ createdAt: -1 });
    
    res.status(200).json({
      success: true,
      orders
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching orders', error: error.message });
  }
};

const acceptOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    
    const order = await Order.findById(orderId);
    
    if (!order) {
      return res.status(404).json({ success: false, message: 'Order not found' });
    }
    
    if (order.status !== 'PENDING') {
      return res.status(400).json({ success: false, message: 'Order is not in pending state' });
    }
    
    order.status = 'ACCEPTED';
    await order.save();
    
    res.status(200).json({
      success: true,
      message: 'Order accepted successfully',
      order
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error accepting order', error: error.message });
  }
};

const fulfillOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { status } = req.body;
    const userId = req.user._id;
    
    if (!status || !['PACKED', 'DISPATCHED', 'DELIVERED'].includes(status)) {
      return res.status(400).json({ success: false, message: 'Invalid status' });
    }
    
    const order = await Order.findById(orderId).populate('productId');
    
    if (!order) {
      return res.status(404).json({ success: false, message: 'Order not found' });
    }
    
    order.status = status;
    
    if (status === 'DELIVERED' && order.paymentStatus === 'PENDING') {
      order.paymentStatus = 'PAID';
      
      await Transaction.create({
        groupId: order.groupId,
        type: 'INCOME',
        amount: order.totalAmount,
        date: new Date(),
        category: 'Product Sale',
        notes: `Sale of ${order.productId.title} - Order #${order._id}`,
        createdBy: userId
      });
      
      const group = await Group.findById(order.groupId);
      if (group) {
        group.cashInHand += order.totalAmount;
        await group.save();
      }
    }
    
    await order.save();
    
    res.status(200).json({
      success: true,
      message: `Order ${status.toLowerCase()} successfully`,
      order
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fulfilling order', error: error.message });
  }
};

module.exports = {
  createOrder,
  getOrders,
  acceptOrder,
  fulfillOrder
};
