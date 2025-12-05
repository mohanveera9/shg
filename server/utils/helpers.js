const { customAlphabet } = require('nanoid');

const generateGroupCode = () => {
  const nanoid = customAlphabet('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 8);
  return nanoid();
};

const generateOTP = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

const calculateEMI = (principal, ratePercent, tenureMonths) => {
  if (ratePercent === 0) {
    return principal / tenureMonths;
  }
  const monthlyRate = ratePercent / (12 * 100);
  const emi = principal * monthlyRate * Math.pow(1 + monthlyRate, tenureMonths) / 
              (Math.pow(1 + monthlyRate, tenureMonths) - 1);
  return Math.round(emi * 100) / 100;
};

const generateLoanSchedule = (principal, emiAmount, tenureMonths, disbursalDate) => {
  const schedule = [];
  const startDate = new Date(disbursalDate);
  
  for (let i = 1; i <= tenureMonths; i++) {
    const dueDate = new Date(startDate);
    dueDate.setMonth(dueDate.getMonth() + i);
    
    schedule.push({
      dueDate,
      amount: emiAmount,
      paid: false
    });
  }
  
  return schedule;
};

const validatePhoneNumber = (phone) => {
  const phoneRegex = /^(\+91)?[6-9]\d{9}$/;
  return phoneRegex.test(phone);
};

const normalizePhoneNumber = (phone) => {
  phone = phone.replace(/\s/g, '');
  if (phone.startsWith('+91')) {
    return phone;
  } else if (phone.length === 10) {
    return '+91' + phone;
  }
  return phone;
};

module.exports = {
  generateGroupCode,
  generateOTP,
  calculateEMI,
  generateLoanSchedule,
  validatePhoneNumber,
  normalizePhoneNumber
};
