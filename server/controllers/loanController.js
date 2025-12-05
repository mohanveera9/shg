const Loan = require('../models/Loan');
const LoanRepayment = require('../models/LoanRepayment');
const Transaction = require('../models/Transaction');
const Group = require('../models/Group');
const { calculateEMI, generateLoanSchedule } = require('../utils/helpers');

const requestLoan = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { requestedAmount, purpose, tenureMonths, documents } = req.body;
    const userId = req.user._id;
    
    if (!requestedAmount || requestedAmount <= 0 || !purpose || !tenureMonths || tenureMonths < 1) {
      return res.status(400).json({ success: false, message: 'Invalid loan request data' });
    }
    
    const loan = await Loan.create({
      groupId,
      memberId: userId,
      requestedAmount,
      purpose,
      tenureMonths,
      documents: documents || [],
      status: 'REQUESTED'
    });
    
    res.status(201).json({
      success: true,
      message: 'Loan request created successfully',
      loan
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error requesting loan', error: error.message });
  }
};

const approveLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    const { approvedAmount, interestRate, tenureMonths, notes } = req.body;
    const userId = req.user._id;
    
    if (!approvedAmount || approvedAmount <= 0) {
      return res.status(400).json({ success: false, message: 'Invalid approved amount' });
    }
    
    const loan = await Loan.findById(loanId);
    
    if (!loan) {
      return res.status(404).json({ success: false, message: 'Loan not found' });
    }
    
    if (loan.status !== 'REQUESTED') {
      return res.status(400).json({ success: false, message: 'Loan is not in requested state' });
    }
    
    const emiAmount = calculateEMI(approvedAmount, interestRate || 0, tenureMonths || loan.tenureMonths);
    
    loan.approvedAmount = approvedAmount;
    loan.interestRate = interestRate || 0;
    loan.tenureMonths = tenureMonths || loan.tenureMonths;
    loan.emiAmount = emiAmount;
    loan.status = 'APPROVED';
    loan.approvedBy = userId;
    loan.remainingBalance = approvedAmount;
    
    await loan.save();
    
    res.status(200).json({
      success: true,
      message: 'Loan approved successfully',
      loan
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error approving loan', error: error.message });
  }
};

const disburseLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    const { disbursalDate, paymentMethod, paymentReference } = req.body;
    const userId = req.user._id;
    
    const loan = await Loan.findById(loanId);
    
    if (!loan) {
      return res.status(404).json({ success: false, message: 'Loan not found' });
    }
    
    if (loan.status !== 'APPROVED') {
      return res.status(400).json({ success: false, message: 'Loan is not in approved state' });
    }
    
    const disbDate = disbursalDate ? new Date(disbursalDate) : new Date();
    const schedule = generateLoanSchedule(loan.approvedAmount, loan.emiAmount, loan.tenureMonths, disbDate);
    
    loan.disbursalDate = disbDate;
    loan.schedule = schedule;
    loan.status = 'DISBURSED';
    loan.disbursedBy = userId;
    loan.paymentMethod = paymentMethod || 'DUMMY_UPI';
    loan.paymentReference = paymentReference || `DUMMY_${Date.now()}`;
    
    await loan.save();
    
    await Transaction.create({
      groupId: loan.groupId,
      type: 'LOAN_DISBURSAL',
      amount: loan.approvedAmount,
      date: disbDate,
      category: 'Loan Disbursal',
      memberId: loan.memberId,
      notes: `Loan disbursed - ${loan.purpose}`,
      createdBy: userId
    });
    
    const group = await Group.findById(loan.groupId);
    if (group) {
      group.cashInHand -= loan.approvedAmount;
      await group.save();
    }
    
    res.status(200).json({
      success: true,
      message: 'Loan disbursed successfully',
      loan
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error disbursing loan', error: error.message });
  }
};

const repayLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    const { amount, paymentMethod, paymentDate } = req.body;
    const userId = req.user._id;
    
    if (!amount || amount <= 0) {
      return res.status(400).json({ success: false, message: 'Invalid repayment amount' });
    }
    
    const loan = await Loan.findById(loanId);
    
    if (!loan) {
      return res.status(404).json({ success: false, message: 'Loan not found' });
    }
    
    if (loan.status !== 'DISBURSED') {
      return res.status(400).json({ success: false, message: 'Loan is not in disbursed state' });
    }
    
    const repayment = await LoanRepayment.create({
      loanId,
      amount,
      paymentDate: paymentDate || new Date(),
      paymentMethod: paymentMethod || 'DUMMY_UPI',
      paymentReference: `DUMMY_${Date.now()}`,
      createdBy: userId
    });
    
    loan.totalPaid += amount;
    loan.remainingBalance = Math.max(0, loan.approvedAmount - loan.totalPaid);
    
    for (let i = 0; i < loan.schedule.length; i++) {
      if (!loan.schedule[i].paid) {
        loan.schedule[i].paid = true;
        loan.schedule[i].paidDate = paymentDate || new Date();
        loan.schedule[i].paidAmount = amount;
        break;
      }
    }
    
    if (loan.remainingBalance <= 0) {
      loan.status = 'CLOSED';
    }
    
    await loan.save();
    
    await Transaction.create({
      groupId: loan.groupId,
      type: 'LOAN_REPAYMENT',
      amount,
      date: paymentDate || new Date(),
      category: 'Loan Repayment',
      memberId: loan.memberId,
      notes: `Loan repayment - ${loan.purpose}`,
      createdBy: userId
    });
    
    const group = await Group.findById(loan.groupId);
    if (group) {
      group.cashInHand += amount;
      await group.save();
    }
    
    res.status(200).json({
      success: true,
      message: 'Loan repayment recorded successfully',
      repayment,
      loan: {
        id: loan._id,
        totalPaid: loan.totalPaid,
        remainingBalance: loan.remainingBalance,
        status: loan.status
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error repaying loan', error: error.message });
  }
};

const getLoans = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { status, memberId } = req.query;
    
    const query = { groupId };
    
    if (status) {
      query.status = status;
    }
    
    if (memberId) {
      query.memberId = memberId;
    }
    
    const loans = await Loan.find(query)
      .populate('memberId', 'name phone')
      .populate('approvedBy', 'name')
      .populate('disbursedBy', 'name')
      .sort({ createdAt: -1 });
    
    res.status(200).json({
      success: true,
      loans
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching loans', error: error.message });
  }
};

const getLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    
    const loan = await Loan.findById(loanId)
      .populate('memberId', 'name phone')
      .populate('approvedBy', 'name')
      .populate('disbursedBy', 'name');
    
    if (!loan) {
      return res.status(404).json({ success: false, message: 'Loan not found' });
    }
    
    const repayments = await LoanRepayment.find({ loanId }).sort({ paymentDate: -1 });
    
    res.status(200).json({
      success: true,
      loan,
      repayments
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching loan', error: error.message });
  }
};

module.exports = {
  requestLoan,
  approveLoan,
  disburseLoan,
  repayLoan,
  getLoans,
  getLoan
};
