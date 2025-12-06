const mongoose = require('mongoose');

const loanRepaymentSchema = new mongoose.Schema({
  emiNumber: Number,
  amount: Number,
  dueDate: Date,
  paidDate: Date,
  status: {
    type: String,
    enum: ['PENDING', 'PAID', 'OVERDUE'],
    default: 'PENDING',
  },
});

const loanSchema = new mongoose.Schema({
  groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group',
    required: true,
  },
  borrowerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  requestedAmount: {
    type: Number,
    required: true,
  },
  approvedAmount: {
    type: Number,
    default: 0,
  },
  disbursedAmount: {
    type: Number,
    default: 0,
  },
  interestRate: {
    type: Number,
    default: 0,
  },
  tenure: {
    type: Number,
    default: 0,
  },
  emiAmount: {
    type: Number,
    default: 0,
  },
  purpose: {
    type: String,
    default: '',
  },
  status: {
    type: String,
    enum: ['REQUESTED', 'APPROVED', 'DISBURSED', 'COMPLETED', 'REJECTED'],
    default: 'REQUESTED',
  },
  repayments: [loanRepaymentSchema],
  documentUrl: {
    type: String,
    default: null,
  },
  approvedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null,
  },
  disbursedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null,
  },
  approvalDate: Date,
  disbursalDate: Date,
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Loan', loanSchema);
