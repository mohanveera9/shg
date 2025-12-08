const Order = require('../models/Order');
const Product = require('../models/Product');
const Group = require('../models/Group');

const getOrders = async (req, res) => {
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

    const orders = await Order.find({ groupId })
      .populate('productId', 'title price photoUrl')
      .populate('customerId', 'name phone')
      .populate('createdBy', 'name phone')
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      orders: orders.map(order => ({
        id: order._id,
        groupId: order.groupId.toString(),
        productId: order.productId,
        productTitle: order.productId?.title || '',
        customerId: order.customerId,
        customerName: order.customerId?.name || '',
        customerPhone: order.customerId?.phone || '',
        quantity: order.quantity,
        totalAmount: order.totalAmount,
        status: order.status,
        orderDate: order.createdAt,
        deliveryDate: order.deliveryDate,
        notes: order.notes,
        createdBy: order.createdBy,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
      })),
    });
  } catch (error) {
    console.error('Error fetching orders:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching orders',
      error: error.message,
    });
  }
};

const createOrder = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { productId, quantity, notes, deliveryDate } = req.body;
    const userId = req.userId;

    if (!productId || !quantity) {
      return res.status(400).json({
        success: false,
        message: 'Product ID and quantity are required',
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

    // Verify product exists and belongs to the group
    const product = await Product.findOne({ _id: productId, groupId });
    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found',
      });
    }

    // Check stock availability
    if (product.stock < quantity) {
      return res.status(400).json({
        success: false,
        message: 'Insufficient stock available',
      });
    }

    const totalAmount = product.price * quantity;

    const order = new Order({
      groupId,
      productId,
      customerId: userId,
      quantity: parseInt(quantity),
      totalAmount,
      status: 'PENDING',
      notes: notes || '',
      deliveryDate: deliveryDate ? new Date(deliveryDate) : null,
      createdBy: userId,
    });

    await order.save();
    await order.populate('productId', 'title price photoUrl');
    await order.populate('customerId', 'name phone');
    await order.populate('createdBy', 'name phone');

    res.status(201).json({
      success: true,
      message: 'Order created successfully',
      order: {
        id: order._id,
        productId: order.productId,
        customerId: order.customerId,
        quantity: order.quantity,
        totalAmount: order.totalAmount,
        status: order.status,
        deliveryDate: order.deliveryDate,
        notes: order.notes,
        createdBy: order.createdBy,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error creating order:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating order',
      error: error.message,
    });
  }
};

const acceptOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    const userId = req.userId;

    const order = await Order.findById(orderId);
    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    // Verify user is a member of the group
    const group = await Group.findById(order.groupId);
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

    if (order.status !== 'PENDING') {
      return res.status(400).json({
        success: false,
        message: 'Order is not in pending status',
      });
    }

    // Check stock availability
    const product = await Product.findById(order.productId);
    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found',
      });
    }

    if (product.stock < order.quantity) {
      return res.status(400).json({
        success: false,
        message: 'Insufficient stock available',
      });
    }

    // Update order status
    order.status = 'ACCEPTED';
    order.updatedAt = new Date();
    await order.save();

    // Reduce product stock
    product.stock -= order.quantity;
    await product.save();

    await order.populate('productId', 'title price photoUrl');
    await order.populate('customerId', 'name phone');
    await order.populate('createdBy', 'name phone');

    res.json({
      success: true,
      message: 'Order accepted successfully',
      order: {
        id: order._id,
        productId: order.productId,
        customerId: order.customerId,
        quantity: order.quantity,
        totalAmount: order.totalAmount,
        status: order.status,
        deliveryDate: order.deliveryDate,
        notes: order.notes,
        createdBy: order.createdBy,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error accepting order:', error);
    res.status(500).json({
      success: false,
      message: 'Error accepting order',
      error: error.message,
    });
  }
};

const fulfillOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    const userId = req.userId;

    const order = await Order.findById(orderId);
    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    // Verify user is a member of the group
    const group = await Group.findById(order.groupId);
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

    if (order.status !== 'ACCEPTED' && order.status !== 'PACKED') {
      return res.status(400).json({
        success: false,
        message: 'Order must be accepted or packed before fulfillment',
      });
    }

    // Update order status
    order.status = 'DELIVERED';
    order.updatedAt = new Date();
    await order.save();

    // Update group cash in hand (income from order)
    group.cashInHand += order.totalAmount;
    await group.save();

    await order.populate('productId', 'title price photoUrl');
    await order.populate('customerId', 'name phone');
    await order.populate('createdBy', 'name phone');

    res.json({
      success: true,
      message: 'Order fulfilled successfully',
      order: {
        id: order._id,
        productId: order.productId,
        customerId: order.customerId,
        quantity: order.quantity,
        totalAmount: order.totalAmount,
        status: order.status,
        deliveryDate: order.deliveryDate,
        notes: order.notes,
        createdBy: order.createdBy,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error fulfilling order:', error);
    res.status(500).json({
      success: false,
      message: 'Error fulfilling order',
      error: error.message,
    });
  }
};

const getOrderDetail = async (req, res) => {
  try {
    const { orderId } = req.params;
    const userId = req.userId;

    const order = await Order.findById(orderId)
      .populate('productId', 'title price photoUrl')
      .populate('customerId', 'name phone')
      .populate('createdBy', 'name phone');

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    // Verify user is a member of the group
    const group = await Group.findById(order.groupId);
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

    res.json({
      success: true,
      order: {
        id: order._id,
        groupId: order.groupId.toString(),
        productId: order.productId?._id?.toString() || '',
        productTitle: order.productId?.title || '',
        customerId: order.customerId?._id?.toString() || '',
        customerName: order.customerId?.name || '',
        customerPhone: order.customerId?.phone || '',
        quantity: order.quantity,
        totalAmount: order.totalAmount,
        status: order.status,
        orderDate: order.createdAt,
        deliveryDate: order.deliveryDate,
        notes: order.notes,
        createdBy: order.createdBy,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error fetching order detail:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching order detail',
      error: error.message,
    });
  }
};

module.exports = {
  getOrders,
  getOrderDetail,
  createOrder,
  acceptOrder,
  fulfillOrder,
};

