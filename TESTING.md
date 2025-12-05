# SHG Management App - Testing Guide

## Backend Testing

### Prerequisites
- MongoDB running
- Backend server running (`npm start` in server directory)

### Test 1: Server Health Check

```bash
curl http://localhost:3000/
```

Expected: JSON response with server info

### Test 2: Complete Authentication Flow

#### Step 1: Send OTP
```bash
curl -X POST http://localhost:3000/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phone": "+919876543210"}'
```

Expected: Success message
Check server console for OTP (6-digit number)

#### Step 2: Verify OTP
```bash
curl -X POST http://localhost:3000/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phone": "+919876543210", "otp": "PASTE_OTP_HERE"}'
```

Expected: Access token and user object
**Save the accessToken for next tests**

### Test 3: Group Creation Flow

#### Create a Group
```bash
# Replace YOUR_TOKEN with actual token
export TOKEN="YOUR_ACCESS_TOKEN"

curl -X POST http://localhost:3000/api/groups/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Test SHG Group",
    "village": "Rampur",
    "block": "Yellandu",
    "district": "Khammam",
    "researchConsent": true
  }'
```

Expected: Group object with groupCode
**Save the groupId and groupCode for next tests**

#### Get My Groups
```bash
curl http://localhost:3000/api/groups/my-groups \
  -H "Authorization: Bearer $TOKEN"
```

### Test 4: Dashboard

```bash
# Replace GROUP_ID with actual group ID
export GROUP_ID="YOUR_GROUP_ID"

curl http://localhost:3000/api/dashboard/$GROUP_ID \
  -H "Authorization: Bearer $TOKEN"
```

Expected: Dashboard data with cash, savings, loans summary

### Test 5: Transaction Flow

#### Create Income Transaction
```bash
curl -X POST http://localhost:3000/api/transactions/$GROUP_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "type": "INCOME",
    "amount": 5000,
    "category": "Sales",
    "notes": "Product sale"
  }'
```

#### Create Expense Transaction
```bash
curl -X POST http://localhost:3000/api/transactions/$GROUP_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "type": "EXPENSE",
    "amount": 2000,
    "category": "Purchase",
    "notes": "Raw materials"
  }'
```

#### Get All Transactions
```bash
curl "http://localhost:3000/api/transactions/$GROUP_ID" \
  -H "Authorization: Bearer $TOKEN"
```

### Test 6: Savings Flow

#### Get Savings
```bash
curl http://localhost:3000/api/savings/$GROUP_ID \
  -H "Authorization: Bearer $TOKEN"
```

#### Add Savings (Treasurer/President only)
```bash
# Get user ID from profile or group members
export USER_ID="YOUR_USER_ID"

curl -X POST http://localhost:3000/api/savings/$GROUP_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "memberId": "'$USER_ID'",
    "amount": 1000
  }'
```

### Test 7: Loan Lifecycle

#### Request Loan
```bash
curl -X POST http://localhost:3000/api/loans/$GROUP_ID/request \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "requestedAmount": 50000,
    "purpose": "Business Expansion",
    "tenureMonths": 12
  }'
```

Expected: Loan object with status "REQUESTED"
**Save the loanId**

#### Approve Loan
```bash
export LOAN_ID="YOUR_LOAN_ID"

curl -X PUT http://localhost:3000/api/loans/$LOAN_ID/approve \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "approvedAmount": 50000,
    "interestRate": 12,
    "tenureMonths": 12
  }'
```

Expected: Loan with status "APPROVED" and calculated EMI

#### Disburse Loan
```bash
curl -X PUT http://localhost:3000/api/loans/$LOAN_ID/disburse \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "disbursalDate": "2025-12-05",
    "paymentMethod": "DUMMY_UPI"
  }'
```

Expected: Loan with status "DISBURSED" and payment schedule

#### Repay Loan
```bash
curl -X POST http://localhost:3000/api/loans/$LOAN_ID/repay \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "amount": 4442,
    "paymentMethod": "DUMMY_UPI"
  }'
```

Expected: Repayment record and updated loan balance

### Test 8: Products & Orders

#### Create Product
```bash
curl -X POST http://localhost:3000/api/products/$GROUP_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Handmade Bags",
    "description": "Beautiful handcrafted bags",
    "price": 500,
    "stock": 50,
    "photoUrl": "/uploads/dummy.jpg"
  }'
```

**Save the productId**

#### Get Products
```bash
curl http://localhost:3000/api/products/$GROUP_ID \
  -H "Authorization: Bearer $TOKEN"
```

#### Create Order
```bash
export PRODUCT_ID="YOUR_PRODUCT_ID"

curl -X POST http://localhost:3000/api/orders/$GROUP_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "productId": "'$PRODUCT_ID'",
    "quantity": 2,
    "buyerContact": "+919876543211",
    "buyerName": "Customer Name"
  }'
```

**Save the orderId**

#### Accept Order
```bash
export ORDER_ID="YOUR_ORDER_ID"

curl -X PUT http://localhost:3000/api/orders/$ORDER_ID/accept \
  -H "Authorization: Bearer $TOKEN"
```

#### Fulfill Order
```bash
curl -X PUT http://localhost:3000/api/orders/$ORDER_ID/fulfill \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"status": "DELIVERED"}'
```

### Test 9: Reports

```bash
curl "http://localhost:3000/api/reports/$GROUP_ID?startDate=2025-12-01&endDate=2025-12-31" \
  -H "Authorization: Bearer $TOKEN"
```

### Test 10: User Profile

#### Get Profile
```bash
curl http://localhost:3000/api/users/profile \
  -H "Authorization: Bearer $TOKEN"
```

#### Update Profile
```bash
curl -X PUT http://localhost:3000/api/users/profile \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Ramya Devi",
    "language": "en"
  }'
```

## Mobile App Testing (Flutter)

### Prerequisites
- Backend server running
- Flutter app compiled and running
- Physical device or emulator

### Test Scenario 1: First Time User - Create Group

1. **Launch App**
   - Should show splash screen for 2 seconds
   - Redirect to language selection

2. **Language Selection**
   - Choose Telugu or English
   - Click Continue

3. **Permissions Screen**
   - Toggle camera and storage (optional)
   - Check research consent checkbox
   - Click Continue

4. **Phone Login**
   - Enter 10-digit phone number (e.g., 9876543210)
   - Click "Send OTP"
   - Check backend console for OTP

5. **OTP Verification**
   - Enter 6-digit OTP from console
   - Click "Verify"
   - Should redirect to Group Selection

6. **Create Group**
   - Click "Create New Group"
   - Fill in:
     - Group Name: "Women SHG"
     - Village: "Rampur"
     - Block: "Yellandu"
     - District: "Khammam"
   - Check research consent
   - Click "Create Group"

7. **Dashboard**
   - Should show group name in app bar
   - Summary cards should show zeros initially
   - Open drawer menu
   - Verify user info displayed

### Test Scenario 2: Join Existing Group

1. **Complete steps 1-5 from Scenario 1**

2. **Join Group**
   - Click "Join Existing Group"
   - Enter group code from Scenario 1
   - Click "Join Group"
   - Should redirect to Dashboard

3. **Verify Membership**
   - Dashboard should show group name
   - Summary data should match group data

### Test Scenario 3: Dashboard Features

1. **Pull to Refresh**
   - Swipe down on dashboard
   - Data should refresh

2. **Navigation**
   - Open drawer menu
   - Click on different menu items
   - Should show "coming soon" messages (expected)

3. **Logout**
   - Open drawer
   - Click Logout
   - Should redirect to language selection
   - Login again to verify persistence

### Test Scenario 4: Multiple Devices

1. **Device 1**: Create group (become PRESIDENT)
2. **Device 2**: Join same group (become MEMBER)
3. Verify both can access dashboard
4. Test role-based permissions

## Role-Based Testing

### As MEMBER
- ✓ View dashboard
- ✓ View transactions
- ✓ Request loan
- ✗ Cannot approve loans
- ✗ Cannot manage all transactions

### As TREASURER
- ✓ All MEMBER permissions
- ✓ Manage transactions
- ✓ Add savings
- ✓ Approve loans
- ✓ Disburse loans

### As PRESIDENT
- ✓ All TREASURER permissions
- ✓ Final approvals
- ✓ Member management

## Edge Cases to Test

### Backend
1. Invalid phone number format
2. Expired OTP
3. Invalid OTP
4. Duplicate group code (should auto-generate new one)
5. Join non-existent group
6. Insufficient group funds for loan disbursal
7. Insufficient product stock for order
8. Invalid transaction amounts (negative, zero)

### Mobile App
1. Network connection loss
2. Invalid API base URL
3. Token expiry
4. Back button navigation
5. App backgrounding/foregrounding
6. Multiple rapid button clicks

## Performance Testing

### Backend
```bash
# Install Apache Bench
# Test concurrent requests
ab -n 1000 -c 10 http://localhost:3000/
```

### Mobile App
- Monitor memory usage
- Check for memory leaks
- Test with large data sets
- Test image loading performance

## Database Verification

```bash
# Connect to MongoDB
mongosh

# Use the database
use shg_app

# Check collections
show collections

# Sample queries
db.users.find().pretty()
db.groups.find().pretty()
db.transactions.find().pretty()
db.loans.find().pretty()

# Check indexes
db.transactions.getIndexes()
db.loans.getIndexes()
```

## Automated Test Script

Create a file `test-api.sh`:

```bash
#!/bin/bash

echo "=== SHG API Test Suite ==="

# Test 1: Health Check
echo "Test 1: Health Check"
curl -s http://localhost:3000/ | grep -q "success" && echo "✓ PASS" || echo "✗ FAIL"

# Test 2: Send OTP
echo "Test 2: Send OTP"
curl -s -X POST http://localhost:3000/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phone": "+919999999999"}' | grep -q "success" && echo "✓ PASS" || echo "✗ FAIL"

# Add more tests...

echo "=== Test Suite Complete ==="
```

Run: `chmod +x test-api.sh && ./test-api.sh`

## Test Checklist

### Backend API
- [ ] All auth endpoints working
- [ ] Group creation/joining working
- [ ] Dashboard returns correct data
- [ ] Transactions update balances correctly
- [ ] Loan lifecycle complete
- [ ] Products and orders working
- [ ] Reports calculate correctly
- [ ] File upload working
- [ ] RBAC enforced correctly
- [ ] Error handling working

### Mobile App
- [ ] Splash screen works
- [ ] Language selection persists
- [ ] Phone auth flow complete
- [ ] Group creation successful
- [ ] Join group working
- [ ] Dashboard displays data
- [ ] Navigation working
- [ ] Logout/login working
- [ ] State management working
- [ ] Error messages shown correctly

### Integration
- [ ] Mobile app communicates with backend
- [ ] Real-time data sync
- [ ] Multiple users in same group
- [ ] Role-based UI updates
- [ ] Token refresh working
- [ ] Network error handling

---

Happy Testing! 🧪
