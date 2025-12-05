const mongoose = require('mongoose');

const loanSchema = new mongoose.Schema({
  groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group',
    required: true
  },
  memberId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  requestedAmount: {
    type: Number,
    required: true,
    min: 0
  },
  approvedAmount: {
    type: Number,
    default: 0
  },
  purpose: {
    type: String,
    required: true
  },
  tenureMonths: {
    type: Number,
    required: true,
    min: 1
  },
  interestRate: {
    type: Number,
    default: 0
  },
  emiAmount: {
    type: Number,
    default: 0
  },
  status: {
    type: String,
    enum: ['REQUESTED', 'APPROVED', 'DISBURSED', 'CLOSED', 'REJECTED'],
    default: 'REQUESTED'
  },
  disbursalDate: {
    type: Date
  },
  documents: [{
    type: String
  }],
  schedule: [{
    dueDate: Date,
    amount: Number,
    paid: {
      type: Boolean,
      default: false
    },
    paidDate: Date,
    paidAmount: Number
  }],
  totalPaid: {
    type: Number,
    default: 0
  },
  remainingBalance: {
    type: Number,
    default: 0
  },
  approvedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  disbursedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  paymentMethod: {
    type: String,
    default: ''
  },
  paymentReference: {
    type: String,
    default: ''
  },
  rejectionReason: {
    type: String,
    default: ''
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

loanSchema.index({ groupId: 1, memberId: 1, status: 1 });

module.exports = mongoose.model('Loan', loanSchema);
