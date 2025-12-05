# SHG Management App - Setup Guide

## Quick Start

### 1. Backend Setup

#### Install Dependencies
```bash
cd server
npm install
```

#### Start MongoDB
Make sure MongoDB is running on your system:
```bash
# Local MongoDB
mongod

# OR use MongoDB Atlas - update MONGODB_URI in .env
```

#### Configure Environment
The `.env` file is already configured with default values:
```
MONGODB_URI=mongodb://localhost:27017/shg_app
JWT_SECRET=shg_jwt_secret_key_2025_secure_random_string
JWT_EXPIRE=7d
REFRESH_TOKEN_SECRET=shg_refresh_token_secret_2025_secure_random
PORT=3000
```

#### Start Server
```bash
npm start
```

Server will run on `http://localhost:3000`

### 2. Frontend Setup (Flutter)

#### Prerequisites
- Flutter SDK installed
- Android Studio or Xcode for mobile development
- Physical device or emulator

#### Install Dependencies
```bash
cd shg_app
flutter pub get
```

#### Configure API URL
Edit `shg_app/lib/config/app_config.dart`:
```dart
// For physical device testing, use your machine's IP
static const String apiBaseUrl = 'http://192.168.1.X:3000/api';

// For emulator
static const String apiBaseUrl = 'http://10.0.2.2:3000/api'; // Android
static const String apiBaseUrl = 'http://localhost:3000/api'; // iOS
```

#### Run the App
```bash
flutter run
```

## Testing the Application

### Backend API Testing

#### 1. Test Server Health
```bash
curl http://localhost:3000/
```

Expected Response:
```json
{
  "success": true,
  "message": "SHG Management API Server",
  "version": "1.0.0"
}
```

#### 2. Test OTP Flow

**Send OTP:**
```bash
curl -X POST http://localhost:3000/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phone": "+919876543210"}'
```

Check server console for OTP:
```
OTP for +919876543210: 123456
```

**Verify OTP:**
```bash
curl -X POST http://localhost:3000/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "+919876543210",
    "otp": "123456"
  }'
```

You'll receive an access token in response.

#### 3. Test Group Creation

```bash
# Replace YOUR_TOKEN with the token from verify-otp response
curl -X POST http://localhost:3000/api/groups/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "name": "Test Group",
    "village": "Test Village",
    "block": "Test Block",
    "district": "Test District",
    "researchConsent": true
  }'
```

### Mobile App Testing

#### User Journey 1: Create Group
1. Open app → Language Selection (choose Telugu or English)
2. Permissions screen → Continue
3. Phone Input → Enter 10-digit number → Send OTP
4. OTP Verification → Enter OTP from server console → Verify
5. Group Selection → Create New Group
6. Fill group details → Create Group
7. View Dashboard

#### User Journey 2: Join Group
1. Complete steps 1-4 above
2. Group Selection → Join Existing Group
3. Enter group code (from created group) → Join
4. View Dashboard

#### Testing Features
- **Dashboard**: View group summary (cash in hand, savings, loans, tasks)
- **Navigation**: Use drawer menu to explore sections
- **Logout**: Test logout and login again

### Common Issues & Solutions

#### Backend Issues

**MongoDB Connection Error:**
```
Error: connect ECONNREFUSED 127.0.0.1:27017
```
Solution: Make sure MongoDB is running (`mongod`)

**Port Already in Use:**
```
Error: listen EADDRINUSE: address already in use :::3000
```
Solution: Change PORT in `.env` or kill process using port 3000

#### Flutter Issues

**Network Connection Failed:**
```
SocketException: Failed to connect
```
Solution:
- Check API URL in `app_config.dart`
- Use machine IP instead of localhost for physical devices
- Ensure backend server is running

**Package Not Found:**
```
Error: Could not resolve package:xxx
```
Solution: Run `flutter pub get`

## Database Schema Overview

### Collections
- **users**: User accounts (phone, name, role, language)
- **otps**: OTP verification (temporary, auto-expires)
- **groups**: SHG groups (name, code, members, balances)
- **transactions**: Financial transactions (income, expense, savings)
- **loans**: Loan records (request, approve, disburse, repay)
- **loanrepayments**: Loan payment history
- **products**: Group products for marketplace
- **orders**: Product orders

## Role-Based Features

### MEMBER
- View dashboard
- Add own transactions
- Request loans
- View products
- Place orders
- View reports

### TREASURER
- All MEMBER features
- Manage all transactions
- Add member savings
- Approve/reject loan requests
- Disburse loans
- Manage products
- Accept orders

### PRESIDENT
- All TREASURER features
- Approve/reject loans
- Manage members
- Final approval authority

### FIELD_OFFICER
- Read-only access to assigned groups
- View dashboards and reports
- No write permissions

### ADMIN
- Full system access
- User management
- Group management

## API Testing Examples

### Create Transaction
```bash
curl -X POST http://localhost:3000/api/transactions/GROUP_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "type": "INCOME",
    "amount": 1000,
    "date": "2025-12-05",
    "category": "Sales",
    "notes": "Product sale"
  }'
```

### Request Loan
```bash
curl -X POST http://localhost:3000/api/loans/GROUP_ID/request \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "requestedAmount": 10000,
    "purpose": "Business",
    "tenureMonths": 12
  }'
```

### Get Dashboard
```bash
curl http://localhost:3000/api/dashboard/GROUP_ID \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Development Tips

### Backend
- Use nodemon for auto-restart: `npm install -g nodemon && nodemon server.js`
- Check MongoDB data: `mongosh` → `use shg_app` → `db.users.find()`
- Enable detailed logs by adding console.log in controllers

### Flutter
- Hot reload: Press `r` in terminal while app is running
- Hot restart: Press `R`
- Debug UI: Enable debug mode in app settings
- Check Flutter doctor: `flutter doctor`

## Production Deployment Checklist

### Backend
- [ ] Change JWT secrets in .env
- [ ] Set up MongoDB Atlas
- [ ] Configure CORS for specific origins
- [ ] Enable rate limiting
- [ ] Set up proper logging
- [ ] Add error tracking (e.g., Sentry)
- [ ] Set up SSL/TLS
- [ ] Configure backup strategy

### Flutter
- [ ] Update API base URL to production
- [ ] Configure app signing
- [ ] Test on multiple devices
- [ ] Optimize images and assets
- [ ] Enable ProGuard/R8 (Android)
- [ ] Set up crash reporting
- [ ] Configure app icons and splash screens
- [ ] Submit to app stores

## Support

For issues or questions:
1. Check the main README.md
2. Review API endpoint documentation
3. Check server console for errors
4. Review Flutter app logs
5. Verify MongoDB connection and data

---

Happy coding! 🚀
