const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const userSchema = new mongoose.Schema({
  phone: {
    type: String,
    required: true,
    unique: true,
    trim: true,
  },
  name: {
    type: String,
    default: '',
  },
  email: {
    type: String,
    default: '',
  },
  profilePhoto: {
    type: String,
    default: null,
  },
  password: {
    type: String,
    default: null,
  },
  role: {
    type: String,
    enum: ['MEMBER', 'TREASURER', 'PRESIDENT', 'FIELD_OFFICER', 'ADMIN'],
    default: 'MEMBER',
  },
  groups: [{
    groupId: mongoose.Schema.Types.ObjectId,
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
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
  researchConsent: {
    type: Boolean,
    default: false,
  },
});

userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  try {
    this.password = await bcrypt.hash(this.password, 10);
    next();
  } catch (error) {
    next(error);
  }
});

userSchema.methods.comparePassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};

module.exports = mongoose.model('User', userSchema);
