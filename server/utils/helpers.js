const { customAlphabet } = require('nanoid');
const QRCode = require('qrcode');

const generateOTP = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

const generateGroupCode = () => {
  const nanoid = customAlphabet('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 8);
  return nanoid();
};

const generateGroupId = () => {
  const nanoid = customAlphabet('abcdefghijklmnopqrstuvwxyz0123456789', 12);
  return `grp_${nanoid()}`;
};

const generateQRCode = async (data) => {
  try {
    const qrData = JSON.stringify(data);
    const qrCode = await QRCode.toDataURL(qrData);
    return qrCode;
  } catch (error) {
    console.error('Error generating QR code:', error);
    return null;
  }
};

const calculateEMI = (principal, ratePerAnnum, tenureInMonths) => {
  const monthlyRate = ratePerAnnum / 12 / 100;
  if (monthlyRate === 0) {
    return Math.round(principal / tenureInMonths);
  }
  const emi =
    (principal * monthlyRate * Math.pow(1 + monthlyRate, tenureInMonths)) /
    (Math.pow(1 + monthlyRate, tenureInMonths) - 1);
  return Math.round(emi);
};

const generateEMISchedule = (amount, emiAmount, tenure) => {
  const schedule = [];
  let remainingAmount = amount;
  const startDate = new Date();

  for (let i = 1; i <= tenure; i++) {
    const dueDate = new Date(startDate);
    dueDate.setMonth(dueDate.getMonth() + i);

    const emiForThisMonth = Math.min(emiAmount, remainingAmount);
    remainingAmount -= emiForThisMonth;

    schedule.push({
      emiNumber: i,
      amount: emiForThisMonth,
      dueDate,
      status: 'PENDING',
    });
  }

  return schedule;
};

module.exports = {
  generateOTP,
  generateGroupCode,
  generateGroupId,
  generateQRCode,
  calculateEMI,
  generateEMISchedule,
};
