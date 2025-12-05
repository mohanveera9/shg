const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group',
    required: true
  },
  productId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product',
    required: true
  },
  quantity: {
    type: Number,
    required: true,
    min: 1
  },
  buyerContact: {
    type: String,
    default: ''
  },
  buyerName: {
    type: String,
    default: ''
  },
  status: {
    type: String,
    enum: ['PENDING', 'ACCEPTED', 'PACKED', 'DISPATCHED', 'DELIVERED', 'CANCELLED'],
    default: 'PENDING'
  },
  paymentStatus: {
    type: String,
    enum: ['PENDING', 'PAID'],
    default: 'PENDING'
  },
  paymentMethod: {
    type: String,
    enum: ['DUMMY_UPI', 'CASH_ON_DELIVERY', 'CASH'],
    default: 'DUMMY_UPI'
  },
  totalAmount: {
    type: Number,
    required: true,
    min: 0
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

orderSchema.index({ groupId: 1, status: 1 });

module.exports = mongoose.model('Order', orderSchema);
