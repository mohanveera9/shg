const mongoose = require('mongoose');

const groupSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  groupCode: {
    type: String,
    required: true,
    unique: true,
    uppercase: true,
  },
  groupId: {
    type: String,
    required: true,
    unique: true,
  },
  qrCode: {
    type: String,
    default: null,
  },
  village: {
    type: String,
    default: '',
  },
  block: {
    type: String,
    default: '',
  },
  district: {
    type: String,
    default: '',
  },
  createdBy: mongoose.Schema.Types.ObjectId,
  members: [{
    userId: mongoose.Schema.Types.ObjectId,
    role: {
      type: String,
      enum: ['MEMBER', 'TREASURER', 'PRESIDENT'],
      default: 'MEMBER',
    },
    joinedAt: {
      type: Date,
      default: Date.now,
    },
    status: {
      type: String,
      enum: ['ACTIVE', 'INACTIVE', 'REMOVED'],
      default: 'ACTIVE',
    },
  }],
  totalMembers: {
    type: Number,
    default: 1,
  },
  cashInHand: {
    type: Number,
    default: 0,
  },
  totalSavings: {
    type: Number,
    default: 0,
  },
  researchConsent: {
    type: Boolean,
    default: false,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Group', groupSchema);
