const Loan = require('../models/Loan');
const Group = require('../models/Group');
const Transaction = require('../models/Transaction');
const { calculateEMI, generateEMISchedule } = require('../utils/helpers');

const getLoans = async (req, res) => {
  try {
    const { groupId } = req.params;
    const userId = req.userId;

    // Verify user is a member of the group
    const group = await Group.findById(groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const isMember = group.members.some(m => m.userId.toString() === userId);
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    const loans = await Loan.find({ groupId })
      .populate('borrowerId', 'name phone')
      .populate('approvedBy', 'name phone')
      .populate('disbursedBy', 'name phone')
      .sort({ createdAt: -1 });

    // Calculate total paid and remaining balance for each loan
    const loansWithCalculations = loans.map(loan => {
      const totalPaid = loan.repayments
        .filter(r => r.status === 'PAID')
        .reduce((sum, r) => sum + (r.amount || 0), 0);
      const remainingBalance = loan.disbursedAmount > 0 
        ? loan.disbursedAmount - totalPaid 
        : null;

      return {
        id: loan._id,
        groupId: loan.groupId.toString(),
        borrowerId: loan.borrowerId,
        borrowerName: loan.borrowerId?.name || '',
        borrowerPhone: loan.borrowerId?.phone || '',
        requestedAmount: loan.requestedAmount,
        approvedAmount: loan.approvedAmount,
        disbursedAmount: loan.disbursedAmount,
        interestRate: loan.interestRate,
        tenure: loan.tenure,
        tenureMonths: loan.tenure, // Map tenure to tenureMonths for frontend
        emiAmount: loan.emiAmount,
        purpose: loan.purpose,
        status: loan.status,
        repayments: loan.repayments,
        documentUrl: loan.documentUrl,
        documents: loan.documentUrl ? [loan.documentUrl] : [],
        approvedBy: loan.approvedBy,
        disbursedBy: loan.disbursedBy,
        approvalDate: loan.approvalDate,
        disbursalDate: loan.disbursalDate,
        requestDate: loan.createdAt, // Map createdAt to requestDate for frontend
        totalPaid: totalPaid,
        remainingBalance: remainingBalance,
        notes: loan.purpose, // Use purpose as notes if needed
        createdAt: loan.createdAt,
        updatedAt: loan.updatedAt,
      };
    });

    res.json({
      success: true,
      loans: loansWithCalculations,
    });
  } catch (error) {
    console.error('Error fetching loans:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching loans',
      error: error.message,
    });
  }
};

const requestLoan = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { requestedAmount, purpose, tenureMonths, interestRate, documentUrl } = req.body;
    const userId = req.userId;

    if (!requestedAmount || !purpose) {
      return res.status(400).json({
        success: false,
        message: 'Requested amount and purpose are required',
      });
    }

    // Verify user is a member of the group
    const group = await Group.findById(groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const isMember = group.members.some(m => m.userId.toString() === userId);
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    const loan = new Loan({
      groupId,
      borrowerId: userId,
      requestedAmount: parseFloat(requestedAmount),
      purpose: purpose,
      tenure: tenureMonths || 12,
      interestRate: interestRate || 12, // Default 12% per annum
      status: 'REQUESTED',
      documentUrl: documentUrl || null,
    });

    await loan.save();
    await loan.populate('borrowerId', 'name phone');

    res.status(201).json({
      success: true,
      message: 'Loan requested successfully',
      loan: {
        id: loan._id,
        groupId: loan.groupId.toString(),
        borrowerId: loan.borrowerId,
        borrowerName: loan.borrowerId?.name || '',
        borrowerPhone: loan.borrowerId?.phone || '',
        requestedAmount: loan.requestedAmount,
        approvedAmount: loan.approvedAmount,
        disbursedAmount: loan.disbursedAmount,
        interestRate: loan.interestRate,
        tenure: loan.tenure,
        tenureMonths: loan.tenure,
        emiAmount: loan.emiAmount,
        purpose: loan.purpose,
        status: loan.status,
        repayments: loan.repayments,
        documentUrl: loan.documentUrl,
        documents: loan.documentUrl ? [loan.documentUrl] : [],
        requestDate: loan.createdAt,
        totalPaid: 0,
        remainingBalance: null,
        createdAt: loan.createdAt,
        updatedAt: loan.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error requesting loan:', error);
    res.status(500).json({
      success: false,
      message: 'Error requesting loan',
      error: error.message,
    });
  }
};

const approveLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    const { approvedAmount, interestRate, tenure, tenureMonths } = req.body;
    const userId = req.userId;

    const loan = await Loan.findById(loanId);
    if (!loan) {
      return res.status(404).json({
        success: false,
        message: 'Loan not found',
      });
    }

    // Verify user is a member of the group and has permission (PRESIDENT or TREASURER)
    const group = await Group.findById(loan.groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const member = group.members.find(m => m.userId.toString() === userId);
    if (!member) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    if (member.role !== 'PRESIDENT' && member.role !== 'TREASURER') {
      return res.status(403).json({
        success: false,
        message: 'Only President or Treasurer can approve loans',
      });
    }

    if (loan.status !== 'REQUESTED') {
      return res.status(400).json({
        success: false,
        message: 'Loan is not in requested status',
      });
    }

    // Update loan details
    loan.approvedAmount = approvedAmount ? parseFloat(approvedAmount) : loan.requestedAmount;
    loan.interestRate = interestRate ? parseFloat(interestRate) : loan.interestRate;
    loan.tenure = tenure ? parseInt(tenure) : (tenureMonths ? parseInt(tenureMonths) : loan.tenure);
    loan.status = 'APPROVED';
    loan.approvedBy = userId;
    loan.approvalDate = new Date();

    // Calculate EMI
    loan.emiAmount = calculateEMI(loan.approvedAmount, loan.interestRate, loan.tenure);

    // Generate EMI schedule
    loan.repayments = generateEMISchedule(loan.approvedAmount, loan.emiAmount, loan.tenure);

    await loan.save();
    await loan.populate('borrowerId', 'name phone');
    await loan.populate('approvedBy', 'name phone');

    const totalPaid = loan.repayments
      .filter(r => r.status === 'PAID')
      .reduce((sum, r) => sum + (r.amount || 0), 0);
    const remainingBalance = loan.disbursedAmount > 0 
      ? loan.disbursedAmount - totalPaid 
      : null;

    res.json({
      success: true,
      message: 'Loan approved successfully',
      loan: {
        id: loan._id,
        groupId: loan.groupId.toString(),
        borrowerId: loan.borrowerId,
        borrowerName: loan.borrowerId?.name || '',
        borrowerPhone: loan.borrowerId?.phone || '',
        requestedAmount: loan.requestedAmount,
        approvedAmount: loan.approvedAmount,
        disbursedAmount: loan.disbursedAmount,
        interestRate: loan.interestRate,
        tenure: loan.tenure,
        tenureMonths: loan.tenure,
        emiAmount: loan.emiAmount,
        purpose: loan.purpose,
        status: loan.status,
        repayments: loan.repayments,
        documentUrl: loan.documentUrl,
        documents: loan.documentUrl ? [loan.documentUrl] : [],
        approvedBy: loan.approvedBy,
        approvalDate: loan.approvalDate,
        requestDate: loan.createdAt,
        totalPaid: totalPaid,
        remainingBalance: remainingBalance,
        createdAt: loan.createdAt,
        updatedAt: loan.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error approving loan:', error);
    res.status(500).json({
      success: false,
      message: 'Error approving loan',
      error: error.message,
    });
  }
};

const disburseLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    const { disbursedAmount } = req.body;
    const userId = req.userId;

    const loan = await Loan.findById(loanId);
    if (!loan) {
      return res.status(404).json({
        success: false,
        message: 'Loan not found',
      });
    }

    // Verify user is a member of the group and has permission (PRESIDENT or TREASURER)
    const group = await Group.findById(loan.groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const member = group.members.find(m => m.userId.toString() === userId);
    if (!member) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    if (member.role !== 'PRESIDENT' && member.role !== 'TREASURER') {
      return res.status(403).json({
        success: false,
        message: 'Only President or Treasurer can disburse loans',
      });
    }

    if (loan.status !== 'APPROVED') {
      return res.status(400).json({
        success: false,
        message: 'Loan must be approved before disbursement',
      });
    }

    const amountToDisburse = disbursedAmount ? parseFloat(disbursedAmount) : loan.approvedAmount;

    // Check if group has sufficient cash
    if (group.cashInHand < amountToDisburse) {
      return res.status(400).json({
        success: false,
        message: 'Insufficient cash in hand to disburse loan',
      });
    }

    // Update loan
    loan.disbursedAmount = amountToDisburse;
    loan.status = 'DISBURSED';
    loan.disbursedBy = userId;
    loan.disbursalDate = new Date();
    await loan.save();

    // Update group cash
    group.cashInHand -= amountToDisburse;
    await group.save();

    // Create transaction record
    const transaction = new Transaction({
      groupId: loan.groupId,
      userId: loan.borrowerId,
      type: 'LOAN_DISBURSAL',
      amount: amountToDisburse,
      category: 'LOAN',
      description: `Loan disbursed - ${loan.purpose}`,
      status: 'COMPLETED',
    });
    await transaction.save();

    await loan.populate('borrowerId', 'name phone');
    await loan.populate('disbursedBy', 'name phone');

    const totalPaid = loan.repayments
      .filter(r => r.status === 'PAID')
      .reduce((sum, r) => sum + (r.amount || 0), 0);
    const remainingBalance = loan.disbursedAmount > 0 
      ? loan.disbursedAmount - totalPaid 
      : null;

    res.json({
      success: true,
      message: 'Loan disbursed successfully',
      loan: {
        id: loan._id,
        groupId: loan.groupId.toString(),
        borrowerId: loan.borrowerId,
        borrowerName: loan.borrowerId?.name || '',
        borrowerPhone: loan.borrowerId?.phone || '',
        requestedAmount: loan.requestedAmount,
        approvedAmount: loan.approvedAmount,
        disbursedAmount: loan.disbursedAmount,
        interestRate: loan.interestRate,
        tenure: loan.tenure,
        tenureMonths: loan.tenure,
        emiAmount: loan.emiAmount,
        purpose: loan.purpose,
        status: loan.status,
        repayments: loan.repayments,
        documentUrl: loan.documentUrl,
        documents: loan.documentUrl ? [loan.documentUrl] : [],
        disbursedBy: loan.disbursedBy,
        disbursalDate: loan.disbursalDate,
        requestDate: loan.createdAt,
        totalPaid: totalPaid,
        remainingBalance: remainingBalance,
        createdAt: loan.createdAt,
        updatedAt: loan.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error disbursing loan:', error);
    res.status(500).json({
      success: false,
      message: 'Error disbursing loan',
      error: error.message,
    });
  }
};

const repayLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    const { emiNumber, amount, receiptUrl, paymentDate, paymentMethod } = req.body;
    const userId = req.userId;

    if (!amount) {
      return res.status(400).json({
        success: false,
        message: 'Amount is required',
      });
    }

    // If emiNumber is not provided, find the next pending EMI
    let emiToPay = null;
    if (emiNumber) {
      emiToPay = parseInt(emiNumber);
    }

    const loan = await Loan.findById(loanId);
    if (!loan) {
      return res.status(404).json({
        success: false,
        message: 'Loan not found',
      });
    }

    // Verify user is a member of the group
    const group = await Group.findById(loan.groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const isMember = group.members.some(m => m.userId.toString() === userId);
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    if (loan.status !== 'DISBURSED') {
      return res.status(400).json({
        success: false,
        message: 'Loan must be disbursed before repayment',
      });
    }

    // Find the EMI in repayments
    let emi = null;
    if (emiToPay) {
      emi = loan.repayments.find(r => r.emiNumber === emiToPay);
      if (!emi) {
        return res.status(404).json({
          success: false,
          message: 'EMI not found',
        });
      }
      if (emi.status === 'PAID') {
        return res.status(400).json({
          success: false,
          message: 'EMI already paid',
        });
      }
    } else {
      // Find the first pending EMI
      emi = loan.repayments.find(r => r.status === 'PENDING');
      if (!emi) {
        return res.status(400).json({
          success: false,
          message: 'No pending EMI found',
        });
      }
    }

    // Update EMI status
    emi.status = 'PAID';
    emi.paidDate = paymentDate ? new Date(paymentDate) : new Date();
    loan.updatedAt = new Date();

    // Check if all EMIs are paid
    const allPaid = loan.repayments.every(r => r.status === 'PAID');
    if (allPaid) {
      loan.status = 'COMPLETED';
    }

    await loan.save();

    // Update group cash
    group.cashInHand += parseFloat(amount);
    await group.save();

    // Create transaction record
    const transaction = new Transaction({
      groupId: loan.groupId,
      userId: loan.borrowerId,
      type: 'LOAN_REPAYMENT',
      amount: parseFloat(amount),
      category: 'LOAN',
      description: `Loan repayment - EMI ${emiNumber}`,
      receiptUrl: receiptUrl || null,
      status: 'COMPLETED',
    });
    await transaction.save();

    await loan.populate('borrowerId', 'name phone');

    const totalPaid = loan.repayments
      .filter(r => r.status === 'PAID')
      .reduce((sum, r) => sum + (r.amount || 0), 0);
    const remainingBalance = loan.disbursedAmount > 0 
      ? loan.disbursedAmount - totalPaid 
      : null;

    res.json({
      success: true,
      message: 'Loan repayment processed successfully',
      loan: {
        id: loan._id,
        groupId: loan.groupId.toString(),
        borrowerId: loan.borrowerId,
        borrowerName: loan.borrowerId?.name || '',
        borrowerPhone: loan.borrowerId?.phone || '',
        requestedAmount: loan.requestedAmount,
        approvedAmount: loan.approvedAmount,
        disbursedAmount: loan.disbursedAmount,
        interestRate: loan.interestRate,
        tenure: loan.tenure,
        tenureMonths: loan.tenure,
        emiAmount: loan.emiAmount,
        purpose: loan.purpose,
        status: loan.status,
        repayments: loan.repayments,
        documentUrl: loan.documentUrl,
        documents: loan.documentUrl ? [loan.documentUrl] : [],
        requestDate: loan.createdAt,
        totalPaid: totalPaid,
        remainingBalance: remainingBalance,
        createdAt: loan.createdAt,
        updatedAt: loan.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error processing loan repayment:', error);
    res.status(500).json({
      success: false,
      message: 'Error processing loan repayment',
      error: error.message,
    });
  }
};

module.exports = {
  getLoans,
  requestLoan,
  approveLoan,
  disburseLoan,
  repayLoan,
};

