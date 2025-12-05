const mongoose = require('mongoose');

const transactionSchema = new mongoose.Schema({
  groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group',
    required: true
  },
  type: {
    type: String,
    enum: ['INCOME', 'EXPENSE', 'SAVINGS', 'LOAN_REPAYMENT', 'LOAN_DISBURSAL'],
    required: true
  },
  amount: {
    type: Number,
    required: true,
    min: 0
  },
  date: {
    type: Date,
    required: true,
    default: Date.now
  },
  category: {
    type: String,
    default: 'General'
  },
  memberId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  notes: {
    type: String,
    default: ''
  },
  receiptUrl: {
    type: String,
    default: ''
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

transactionSchema.index({ groupId: 1, date: -1 });

module.exports = mongoose.model('Transaction', transactionSchema);
