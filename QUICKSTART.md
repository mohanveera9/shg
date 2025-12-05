# SHG Management App - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Start Backend (2 minutes)

```bash
# Terminal 1 - Start MongoDB
mongod

# Terminal 2 - Start Node.js Server
cd server
npm install  # First time only
npm start
```

✅ Server running at `http://localhost:3000`

### Step 2: Test Backend (1 minute)

```bash
# Test server health
curl http://localhost:3000/

# Send OTP
curl -X POST http://localhost:3000/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phone": "+919876543210"}'

# Check console for OTP
```

### Step 3: Run Flutter App (2 minutes)

```bash
# In new terminal
cd shg_app
flutter pub get  # First time only
flutter run
```

## 📱 First User Journey

1. **Launch app** → Language Selection → Choose Telugu/English
2. **Permissions** → Continue
3. **Phone Number** → Enter 9876543210 → Send OTP
4. **Check backend console** for OTP (6 digits)
5. **Enter OTP** → Verify
6. **Create Group** → Fill details → Create
7. **View Dashboard** ✅

## 🎯 Key Features to Test

### Backend Testing
```bash
# 1. Authentication
curl -X POST localhost:3000/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phone": "+919876543210", "otp": "YOUR_OTP"}'

# Save the token
export TOKEN="your_access_token"

# 2. Create Group
curl -X POST localhost:3000/api/groups/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"name": "Test Group", "village": "Village1", "district": "District1"}'

# Save the group ID
export GROUP_ID="your_group_id"

# 3. View Dashboard
curl localhost:3000/api/dashboard/$GROUP_ID \
  -H "Authorization: Bearer $TOKEN"

# 4. Add Transaction
curl -X POST localhost:3000/api/transactions/$GROUP_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"type": "INCOME", "amount": 5000, "category": "Sales"}'

# 5. Request Loan
curl -X POST localhost:3000/api/loans/$GROUP_ID/request \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"requestedAmount": 10000, "purpose": "Business", "tenureMonths": 12}'
```

### Mobile App Testing
1. ✅ Language selection persists
2. ✅ OTP authentication works
3. ✅ Group creation successful
4. ✅ Dashboard displays data
5. ✅ Drawer navigation works
6. ✅ Logout and re-login works

## 📊 Project Structure

```
shg/
├── server/                 # Node.js Backend
│   ├── models/            # 8 MongoDB schemas
│   ├── controllers/       # 10 controllers
│   ├── routes/            # 11 route files
│   ├── middleware/        # Auth, RBAC, Upload
│   └── server.js          # Main entry point
│
├── shg_app/               # Flutter Frontend
│   ├── lib/
│   │   ├── config/        # App config, routes, theme
│   │   ├── models/        # Data models
│   │   ├── providers/     # State management
│   │   ├── services/      # API services
│   │   └── screens/       # 10+ UI screens
│   └── assets/
│       └── locales/       # Telugu & English
│
└── docs/                  # Documentation
    ├── README.md
    ├── SETUP.md
    ├── API_DOCUMENTATION.md
    ├── TESTING.md
    └── PROJECT_STATUS.md
```

## 🔑 Key Concepts

### Roles & Permissions
- **MEMBER**: View data, request loans, place orders
- **TREASURER**: Manage transactions, approve loans, disburse funds
- **PRESIDENT**: Final approvals, member management
- **FIELD_OFFICER**: Read-only access
- **ADMIN**: Full system access

### Group Codes
- 8-character alphanumeric (e.g., ABC12345)
- Auto-generated on group creation
- Used for joining groups

### Transaction Types
- INCOME: Money coming in
- EXPENSE: Money going out
- SAVINGS: Member savings contributions
- LOAN_REPAYMENT: Loan payments received
- LOAN_DISBURSAL: Loan amounts paid out

### Loan Lifecycle
1. **REQUESTED** → Member requests loan
2. **APPROVED** → Treasurer/President approves
3. **DISBURSED** → Funds transferred to member
4. **CLOSED** → Fully repaid

## 📚 Documentation

- **[README.md](README.md)** - Project overview and features
- **[SETUP.md](SETUP.md)** - Detailed setup instructions
- **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - Complete API reference
- **[TESTING.md](TESTING.md)** - Testing guide with examples
- **[PROJECT_STATUS.md](PROJECT_STATUS.md)** - Implementation status

## 🆘 Common Issues

### "MongoDB connection error"
```bash
# Start MongoDB
mongod
```

### "Port 3000 already in use"
```bash
# Change PORT in server/.env
PORT=3001
```

### "Flutter command not found"
```bash
# Install Flutter SDK first
# https://docs.flutter.dev/get-started/install
```

### "Network error in app"
```dart
// Update API URL in shg_app/lib/config/app_config.dart
// Use your machine's IP for physical devices
static const String apiBaseUrl = 'http://192.168.1.X:3000/api';
```

## 💡 Tips

1. **Check server console** for OTP codes
2. **Use Postman** for easier API testing
3. **Enable hot reload** in Flutter (press 'r')
4. **Check MongoDB data** with `mongosh`
5. **Read error messages** in terminal and app

## 🎓 Learn More

### Backend
- Express.js: https://expressjs.com/
- MongoDB: https://www.mongodb.com/docs/
- JWT: https://jwt.io/

### Frontend
- Flutter: https://flutter.dev/docs
- Provider: https://pub.dev/packages/provider
- Material Design: https://material.io/design

## ✅ Quick Verification

Run these commands to verify setup:

```bash
# Backend health
curl http://localhost:3000/

# MongoDB connection
mongosh --eval "db.version()"

# Flutter setup (when available)
flutter doctor

# Node.js version
node --version

# npm version
npm --version
```

## 🎉 You're Ready!

Your SHG Management App is set up and ready to use. Start by:

1. Creating your first group
2. Adding members
3. Recording transactions
4. Managing loans
5. Setting up products

Happy coding! 🚀

---

For detailed information, see:
- Setup issues: [SETUP.md](SETUP.md)
- API details: [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
- Testing: [TESTING.md](TESTING.md)
