# SHG Management API Documentation

Base URL: `http://localhost:3000/api`

## Authentication

All authenticated endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer YOUR_ACCESS_TOKEN
```

### Send OTP
**POST** `/auth/send-otp`

Request:
```json
{
  "phone": "+919876543210"
}
```

Response:
```json
{
  "success": true,
  "message": "OTP sent successfully",
  "phone": "+919876543210"
}
```

### Verify OTP
**POST** `/auth/verify-otp`

Request:
```json
{
  "phone": "+919876543210",
  "otp": "123456"
}
```

Response:
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "phone": "+919876543210",
    "name": "",
    "role": "MEMBER",
    "language": "te",
    "groups": []
  }
}
```

### Logout
**POST** `/auth/logout` 🔒

Response:
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

## Groups

### Create Group
**POST** `/groups/create` 🔒

Request:
```json
{
  "name": "Women SHG Group",
  "village": "Rampur",
  "block": "Yellandu",
  "district": "Khammam",
  "foundingMembers": ["+919876543211", "+919876543212"],
  "researchConsent": true
}
```

Response:
```json
{
  "success": true,
  "message": "Group created successfully",
  "group": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "name": "Women SHG Group",
    "groupCode": "ABC12345",
    "qrData": "{\"groupCode\":\"ABC12345\",\"groupName\":\"Women SHG Group\"}",
    "creatorRole": "PRESIDENT",
    "village": "Rampur",
    "block": "Yellandu",
    "district": "Khammam",
    "members": [...]
  }
}
```

### Join Group
**POST** `/groups/join` 🔒

Request:
```json
{
  "groupCode": "ABC12345"
}
```

Response:
```json
{
  "success": true,
  "message": "Joined group successfully",
  "group": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "name": "Women SHG Group",
    "village": "Rampur",
    "block": "Yellandu",
    "district": "Khammam"
  },
  "membership": {
    "role": "MEMBER",
    "status": "ACTIVE"
  }
}
```

### Get My Groups
**GET** `/groups/my-groups` 🔒

Response:
```json
{
  "success": true,
  "groups": [
    {
      "id": "60f7b3b3b3b3b3b3b3b3b3b3",
      "name": "Women SHG Group",
      "groupCode": "ABC12345",
      "village": "Rampur",
      "block": "Yellandu",
      "district": "Khammam",
      "userRole": "PRESIDENT"
    }
  ]
}
```

### Get Group Details
**GET** `/groups/:groupId` 🔒

Response:
```json
{
  "success": true,
  "group": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "name": "Women SHG Group",
    "groupCode": "ABC12345",
    "members": [...],
    "cashInHand": 50000,
    "totalSavings": 100000
  }
}
```

## Dashboard

### Get Dashboard
**GET** `/dashboard/:groupId` 🔒

Response:
```json
{
  "success": true,
  "groupName": "Women SHG Group",
  "todayTasks": 5,
  "cashInHand": 50000,
  "groupSavings": 100000,
  "dueLoans": 3,
  "topProduct": {
    "name": "Handmade Bags",
    "sales": 25
  },
  "userRole": "PRESIDENT"
}
```

## Transactions

### Get Transactions
**GET** `/transactions/:groupId?type=&startDate=&endDate=&memberId=` 🔒

Query Parameters:
- `type`: INCOME | EXPENSE | SAVINGS | LOAN_REPAYMENT | LOAN_DISBURSAL
- `startDate`: ISO date string
- `endDate`: ISO date string
- `memberId`: User ID

Response:
```json
{
  "success": true,
  "transactions": [
    {
      "id": "60f7b3b3b3b3b3b3b3b3b3b3",
      "type": "INCOME",
      "amount": 5000,
      "date": "2025-12-05T00:00:00.000Z",
      "category": "Sales",
      "notes": "Product sale",
      "memberId": {...},
      "createdBy": {...}
    }
  ]
}
```

### Create Transaction
**POST** `/transactions/:groupId` 🔒 (RBAC: MEMBER, TREASURER, PRESIDENT)

Request:
```json
{
  "type": "INCOME",
  "amount": 5000,
  "date": "2025-12-05",
  "category": "Sales",
  "memberId": "60f7b3b3b3b3b3b3b3b3b3b3",
  "notes": "Product sale",
  "receiptUrl": "/uploads/receipt.jpg"
}
```

Response:
```json
{
  "success": true,
  "message": "Transaction created successfully",
  "transaction": {...},
  "updatedBalances": {
    "cashInHand": 55000,
    "totalSavings": 100000
  }
}
```

## Savings

### Get Savings
**GET** `/savings/:groupId` 🔒

Response:
```json
{
  "success": true,
  "savingsByMember": [
    {
      "memberId": "60f7b3b3b3b3b3b3b3b3b3b3",
      "memberName": "Ramya",
      "memberPhone": "+919876543210",
      "amount": 10000
    }
  ],
  "groupTotalSavings": 100000
}
```

### Add Savings
**POST** `/savings/:groupId` 🔒 (RBAC: TREASURER, PRESIDENT)

Request:
```json
{
  "memberId": "60f7b3b3b3b3b3b3b3b3b3b3",
  "amount": 1000,
  "date": "2025-12-05"
}
```

Response:
```json
{
  "success": true,
  "message": "Savings added successfully",
  "transaction": {...},
  "memberSavings": 11000,
  "groupTotalSavings": 101000
}
```

## Loans

### Request Loan
**POST** `/loans/:groupId/request` 🔒 (RBAC: MEMBER, TREASURER, PRESIDENT)

Request:
```json
{
  "requestedAmount": 50000,
  "purpose": "Business Expansion",
  "tenureMonths": 12,
  "documents": ["/uploads/doc1.pdf", "/uploads/doc2.pdf"]
}
```

Response:
```json
{
  "success": true,
  "message": "Loan request created successfully",
  "loan": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "requestedAmount": 50000,
    "purpose": "Business Expansion",
    "status": "REQUESTED"
  }
}
```

### Approve Loan
**PUT** `/loans/:loanId/approve` 🔒

Request:
```json
{
  "approvedAmount": 50000,
  "interestRate": 12,
  "tenureMonths": 12,
  "notes": "Approved"
}
```

Response:
```json
{
  "success": true,
  "message": "Loan approved successfully",
  "loan": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "approvedAmount": 50000,
    "interestRate": 12,
    "emiAmount": 4442.33,
    "status": "APPROVED"
  }
}
```

### Disburse Loan
**PUT** `/loans/:loanId/disburse` 🔒

Request:
```json
{
  "disbursalDate": "2025-12-05",
  "paymentMethod": "DUMMY_UPI",
  "paymentReference": "REF123"
}
```

Response:
```json
{
  "success": true,
  "message": "Loan disbursed successfully",
  "loan": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "status": "DISBURSED",
    "schedule": [...]
  }
}
```

### Repay Loan
**POST** `/loans/:loanId/repay` 🔒

Request:
```json
{
  "amount": 4442.33,
  "paymentMethod": "DUMMY_UPI",
  "paymentDate": "2025-12-05"
}
```

Response:
```json
{
  "success": true,
  "message": "Loan repayment recorded successfully",
  "repayment": {...},
  "loan": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "totalPaid": 4442.33,
    "remainingBalance": 45557.67,
    "status": "DISBURSED"
  }
}
```

### Get Loans
**GET** `/loans/:groupId?status=&memberId=` 🔒

Response:
```json
{
  "success": true,
  "loans": [...]
}
```

### Get Loan Details
**GET** `/loans/detail/:loanId` 🔒

Response:
```json
{
  "success": true,
  "loan": {...},
  "repayments": [...]
}
```

## Products

### Create Product
**POST** `/products/:groupId` 🔒 (RBAC: MEMBER, TREASURER, PRESIDENT)

Request:
```json
{
  "title": "Handmade Bags",
  "description": "Beautiful handcrafted bags",
  "price": 500,
  "stock": 50,
  "photoUrl": "/uploads/bag.jpg"
}
```

Response:
```json
{
  "success": true,
  "message": "Product created successfully",
  "product": {...}
}
```

### Get Products
**GET** `/products/:groupId` 🔒

Response:
```json
{
  "success": true,
  "products": [...]
}
```

### Get Product Details
**GET** `/products/detail/:productId` 🔒

Response:
```json
{
  "success": true,
  "product": {...}
}
```

### Update Product
**PUT** `/products/:productId` 🔒

Request:
```json
{
  "title": "Updated Title",
  "price": 600,
  "stock": 40
}
```

Response:
```json
{
  "success": true,
  "message": "Product updated successfully",
  "product": {...}
}
```

## Orders

### Create Order
**POST** `/orders/:groupId` 🔒

Request:
```json
{
  "productId": "60f7b3b3b3b3b3b3b3b3b3b3",
  "quantity": 2,
  "buyerContact": "+919876543210",
  "buyerName": "John Doe",
  "paymentMethod": "DUMMY_UPI"
}
```

Response:
```json
{
  "success": true,
  "message": "Order created successfully",
  "order": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "status": "PENDING",
    "paymentStatus": "PENDING",
    "totalAmount": 1000
  }
}
```

### Get Orders
**GET** `/orders/:groupId?status=` 🔒

Response:
```json
{
  "success": true,
  "orders": [...]
}
```

### Accept Order
**PUT** `/orders/:orderId/accept` 🔒

Response:
```json
{
  "success": true,
  "message": "Order accepted successfully",
  "order": {...}
}
```

### Fulfill Order
**PUT** `/orders/:orderId/fulfill` 🔒

Request:
```json
{
  "status": "DELIVERED"
}
```
Valid statuses: PACKED, DISPATCHED, DELIVERED

Response:
```json
{
  "success": true,
  "message": "Order delivered successfully",
  "order": {...}
}
```

## Reports

### Get Reports
**GET** `/reports/:groupId?startDate=&endDate=` 🔒

Response:
```json
{
  "success": true,
  "period": {
    "startDate": "2025-12-01T00:00:00.000Z",
    "endDate": "2025-12-31T23:59:59.999Z"
  },
  "income": 50000,
  "expense": 20000,
  "savingsByMember": [...],
  "outstandingLoans": 100000,
  "topProducts": [...]
}
```

### Export Report
**POST** `/reports/:groupId/export` 🔒

Request:
```json
{
  "format": "CSV",
  "startDate": "2025-12-01",
  "endDate": "2025-12-31"
}
```

Response:
```json
{
  "success": true,
  "message": "Export functionality coming soon",
  "downloadUrl": "dummy_export_CSV_1733400000000.csv"
}
```

## Users

### Get Profile
**GET** `/users/profile` 🔒

Response:
```json
{
  "success": true,
  "user": {
    "id": "60f7b3b3b3b3b3b3b3b3b3b3",
    "phone": "+919876543210",
    "name": "Ramya",
    "role": "MEMBER",
    "language": "te",
    "groups": [...]
  }
}
```

### Update Profile
**PUT** `/users/profile` 🔒

Request:
```json
{
  "name": "Ramya Devi",
  "language": "en",
  "profilePhotoUrl": "/uploads/profile.jpg"
}
```

Response:
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "user": {...}
}
```

## Upload

### Upload File
**POST** `/upload/file` 🔒

Content-Type: `multipart/form-data`

Form Data:
- `file`: File (image or PDF, max 5MB)

Response:
```json
{
  "success": true,
  "message": "File uploaded successfully",
  "fileUrl": "/uploads/file-1733400000000-123456789.jpg"
}
```

---

## Error Responses

All endpoints return errors in this format:

```json
{
  "success": false,
  "message": "Error message here"
}
```

Common HTTP Status Codes:
- `200`: Success
- `201`: Created
- `400`: Bad Request
- `401`: Unauthorized
- `403`: Forbidden
- `404`: Not Found
- `500`: Internal Server Error

## Rate Limiting

Currently not implemented. Consider adding rate limiting in production.

## Notes

- 🔒 indicates authentication required
- All dates are in ISO 8601 format
- All amounts are in INR (Indian Rupees)
- Phone numbers should be in +91XXXXXXXXXX format
- Group codes are 8-character alphanumeric strings
- OTP expires in 10 minutes
- Access tokens expire in 7 days
