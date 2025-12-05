const User = require('../models/User');
const OTP = require('../models/OTP');
const { generateAccessToken, generateRefreshToken } = require('../utils/jwt');
const { generateOTP, validatePhoneNumber, normalizePhoneNumber } = require('../utils/helpers');

const sendOTP = async (req, res) => {
  try {
    let { phone } = req.body;
    
    if (!phone) {
      return res.status(400).json({ success: false, message: 'Phone number is required' });
    }
    
    phone = normalizePhoneNumber(phone);
    
    if (!validatePhoneNumber(phone)) {
      return res.status(400).json({ success: false, message: 'Invalid phone number format' });
    }
    
    const otp = generateOTP();
    
    await OTP.deleteMany({ phone, verified: false });
    
    await OTP.create({
      phone,
      otp,
      expiresAt: new Date(Date.now() + 10 * 60 * 1000)
    });
    
    console.log(`OTP for ${phone}: ${otp}`);
    
    res.status(200).json({ 
      success: true, 
      message: 'OTP sent successfully',
      phone 
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error sending OTP', error: error.message });
  }
};

const verifyOTP = async (req, res) => {
  try {
    let { phone, otp } = req.body;
    
    if (!phone || !otp) {
      return res.status(400).json({ success: false, message: 'Phone and OTP are required' });
    }
    
    phone = normalizePhoneNumber(phone);
    
    const otpRecord = await OTP.findOne({ 
      phone, 
      otp, 
      verified: false,
      expiresAt: { $gt: new Date() }
    });
    
    if (!otpRecord) {
      return res.status(400).json({ success: false, message: 'Invalid or expired OTP' });
    }
    
    otpRecord.verified = true;
    await otpRecord.save();
    
    let user = await User.findOne({ phone });
    
    if (!user) {
      user = await User.create({ phone });
    }
    
    const accessToken = generateAccessToken(user._id);
    const refreshToken = generateRefreshToken(user._id);
    
    res.status(200).json({
      success: true,
      message: 'OTP verified successfully',
      accessToken,
      refreshToken,
      user: {
        id: user._id,
        phone: user.phone,
        name: user.name,
        role: user.role,
        language: user.language,
        groups: user.groups
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error verifying OTP', error: error.message });
  }
};

const logout = async (req, res) => {
  try {
    res.status(200).json({ success: true, message: 'Logged out successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error logging out', error: error.message });
  }
};

module.exports = {
  sendOTP,
  verifyOTP,
  logout
};
