const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  phone: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  name: {
    type: String,
    default: ''
  },
  role: {
    type: String,
    enum: ['MEMBER', 'TREASURER', 'PRESIDENT', 'FIELD_OFFICER', 'ADMIN'],
    default: 'MEMBER'
  },
  groups: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group'
  }],
  language: {
    type: String,
    enum: ['te', 'en'],
    default: 'te'
  },
  profilePhotoUrl: {
    type: String,
    default: ''
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('User', userSchema);
