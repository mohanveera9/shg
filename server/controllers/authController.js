const User = require('../models/User');
const OTP = require('../models/OTP');
const { generateOTP } = require('../utils/helpers');
const { generateAccessToken, generateRefreshToken } = require('../utils/jwt');

const sendOTP = async (req, res) => {
  try {
    const { phone } = req.body;

    if (!phone) {
      return res.status(400).json({
        success: false,
        message: 'Phone number is required',
      });
    }

    const otp = generateOTP();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000);

    await OTP.findOneAndUpdate(
      { phone },
      { otp, expiresAt, attempts: 0 },
      { upsert: true, new: true }
    );

    console.log(`OTP for ${phone}: ${otp}`);

    res.json({
      success: true,
      message: 'OTP sent successfully',
      otp: process.env.NODE_ENV === 'development' ? otp : undefined,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error sending OTP',
      error: error.message,
    });
  }
};

const verifyOTP = async (req, res) => {
  try {
    const { phone, otp } = req.body;

    if (!phone || !otp) {
      return res.status(400).json({
        success: false,
        message: 'Phone and OTP are required',
      });
    }

    const otpRecord = await OTP.findOne({ phone });

    if (!otpRecord) {
      return res.status(400).json({
        success: false,
        message: 'OTP not found or expired',
      });
    }

    if (otpRecord.expiresAt < new Date()) {
      return res.status(400).json({
        success: false,
        message: 'OTP has expired',
      });
    }

    if (otpRecord.attempts >= 3) {
      return res.status(400).json({
        success: false,
        message: 'Too many attempts. Please request a new OTP',
      });
    }

    if (otpRecord.otp !== otp) {
      otpRecord.attempts += 1;
      await otpRecord.save();
      return res.status(400).json({
        success: false,
        message: 'Invalid OTP',
      });
    }

    let user = await User.findOne({ phone });

    if (!user) {
      user = new User({
        phone,
        name: '',
        role: 'MEMBER',
      });
      await user.save();
    }

    const accessToken = generateAccessToken(user._id);
    const refreshToken = generateRefreshToken(user._id);

    await OTP.deleteOne({ phone });

    res.json({
      success: true,
      message: 'OTP verified successfully',
      accessToken,
      refreshToken,
      user: {
        id: user._id,
        phone: user.phone,
        name: user.name,
        email: user.email,
        profilePhoto: user.profilePhoto,
        role: user.role,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error verifying OTP',
      error: error.message,
    });
  }
};

const logout = async (req, res) => {
  try {
    res.json({
      success: true,
      message: 'Logged out successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error logging out',
      error: error.message,
    });
  }
};

module.exports = {
  sendOTP,
  verifyOTP,
  logout,
};
