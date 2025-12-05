# SHG Management Application

A comprehensive Self-Help Group (SHG) management mobile application built with **Flutter** (frontend), **Node.js + Express** (backend), and **MongoDB** (database).

## 📱 Features

### Core Functionality
- **Authentication**: Phone number + OTP verification
- **Multi-language Support**: Telugu (తెలుగు) and English
- **Group Management**: Create and join SHG groups with unique codes and QR codes
- **Role-Based Access Control**: MEMBER, TREASURER, PRESIDENT, FIELD_OFFICER, ADMIN
- **Dashboard**: Real-time group metrics and quick actions

### Financial Management
- **Daily Bookkeeping**: Track income, expenses, and transactions
- **Savings Management**: Member-wise savings tracking
- **Loan Lifecycle**: Request → Approve → Disburse → Repay
- **EMI Calculations**: Automatic EMI computation with schedules

### Marketplace
- **Products**: Create and manage group products
- **Orders**: Place and track orders with status updates
- **Dummy Payments**: Simulated payment integration

### Reports & Analytics
- **Financial Reports**: Income, expenses, savings by member
- **Export Functionality**: CSV and PDF export (dummy implementation)

## 🛠 Tech Stack

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT (JSON Web Tokens)
- **File Upload**: Multer
- **Utilities**: bcrypt, nanoid, cors, dotenv

### Frontend
- **Framework**: Flutter
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: shared_preferences, flutter_secure_storage
- **Image Handling**: image_picker, file_picker
- **QR Code**: qr_flutter, qr_code_scanner
- **Localization**: intl package

## 📁 Project Structure

```
shg/
├── server/                    # Backend (Node.js + Express)
│   ├── config/               # Database and environment config
│   ├── models/               # MongoDB schemas
│   ├── routes/               # API routes
│   ├── controllers/          # Business logic
│   ├── middleware/           # Auth, RBAC, upload
│   ├── utils/                # Helper functions
│   ├── uploads/              # File uploads directory
│   ├── server.js             # Main server file
│   └── package.json          # Dependencies
│
└── shg_app/                  # Frontend (Flutter)
    ├── lib/
    │   ├── config/           # App configuration, routes, theme
    │   ├── models/           # Data models
    │   ├── providers/        # State management
    │   ├── services/         # API and storage services
    │   ├── screens/          # UI screens
    │   ├── widgets/          # Reusable widgets
    │   ├── utils/            # Utility functions
    │   ├── main.dart         # Entry point
    │   └── app.dart          # App widget
    ├── assets/
    │   ├── images/           # Image assets
    │   └── locales/          # Translation files
    └── pubspec.yaml          # Flutter dependencies
```

## 🚀 Getting Started

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (local or Atlas)
- Flutter SDK (v3.0 or higher)
- Android Studio / Xcode (for mobile development)

### Backend Setup

1. **Navigate to server directory**
   ```bash
   cd server
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   
   Edit `server/.env`:
   ```
   MONGODB_URI=mongodb://localhost:27017/shg_app
   JWT_SECRET=your_jwt_secret_key
   JWT_EXPIRE=7d
   REFRESH_TOKEN_SECRET=your_refresh_token_secret
   PORT=3000
   ```

4. **Start MongoDB**
   ```bash
   # If using local MongoDB
   mongod
   ```

5. **Run the server**
   ```bash
   npm start
   ```

   Server will run on `http://localhost:3000`

### Frontend Setup

1. **Navigate to Flutter app directory**
   ```bash
   cd shg_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API base URL**
   
   Edit `shg_app/lib/config/app_config.dart`:
   ```dart
   static const String apiBaseUrl = 'http://YOUR_IP:3000/api';
   ```
   
   > Note: Use your machine's IP address instead of `localhost` for testing on physical devices

4. **Run the app**
   ```bash
   flutter run
   ```

## 📋 API Endpoints

### Authentication
- `POST /api/auth/send-otp` - Send OTP to phone
- `POST /api/auth/verify-otp` - Verify OTP and login
- `POST /api/auth/logout` - Logout user

### Groups
- `POST /api/groups/create` - Create new group
- `POST /api/groups/join` - Join existing group
- `GET /api/groups/my-groups` - Get user's groups
- `GET /api/groups/:groupId` - Get group details

### Dashboard
- `GET /api/dashboard/:groupId` - Get dashboard data

### Transactions
- `GET /api/transactions/:groupId` - Get transactions
- `POST /api/transactions/:groupId` - Create transaction

### Savings
- `GET /api/savings/:groupId` - Get savings data
- `POST /api/savings/:groupId` - Add savings

### Loans
- `POST /api/loans/:groupId/request` - Request loan
- `PUT /api/loans/:loanId/approve` - Approve loan
- `PUT /api/loans/:loanId/disburse` - Disburse loan
- `POST /api/loans/:loanId/repay` - Repay loan
- `GET /api/loans/:groupId` - Get all loans
- `GET /api/loans/detail/:loanId` - Get loan details

### Products
- `POST /api/products/:groupId` - Create product
- `GET /api/products/:groupId` - Get all products
- `GET /api/products/detail/:productId` - Get product details
- `PUT /api/products/:productId` - Update product

### Orders
- `POST /api/orders/:groupId` - Create order
- `GET /api/orders/:groupId` - Get all orders
- `PUT /api/orders/:orderId/accept` - Accept order
- `PUT /api/orders/:orderId/fulfill` - Fulfill order

### Reports
- `GET /api/reports/:groupId` - Get reports
- `POST /api/reports/:groupId/export` - Export report

### Users
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile

### Upload
- `POST /api/upload/file` - Upload file

## 🧪 Testing

### Test OTP Flow
The OTP is logged to the server console. Look for:
```
OTP for +919876543210: 123456
```

### Test User Roles
Create a group and test different role permissions:
- **PRESIDENT**: Can approve loans
- **TREASURER**: Can manage bookkeeping, disburse loans
- **MEMBER**: Can request loans, view data

### Test Data
You can create dummy users, groups, and transactions through the API or mobile app.

## 🔐 Security Features
- JWT-based authentication
- Secure token storage (Flutter Secure Storage)
- Password hashing with bcrypt
- Role-based access control
- Phone number validation

## 🌐 Localization
Supports Telugu and English with translation files:
- `shg_app/assets/locales/te.json`
- `shg_app/assets/locales/en.json`

## 📝 Key Implementation Notes

1. **Dummy Payment**: All payment integrations are simulated with 2-second delays
2. **Group Codes**: 8-character alphanumeric codes generated using nanoid
3. **QR Codes**: JSON format containing groupCode and groupName
4. **File Uploads**: Stored in `server/uploads/` directory
5. **OTP Expiry**: 10 minutes
6. **Token Expiry**: 7 days (access token)

## 🚧 Future Enhancements
- Push notifications
- Offline sync capability
- Real payment gateway integration
- Voice assistant feature
- Advanced analytics and charts
- Web admin portal
- Multi-group switching in UI
- Advanced QR scanner implementation

## 📄 License
This project is built for educational and development purposes.

## 👥 Contributors
Built as a comprehensive SHG management solution.

## 🐛 Known Issues
- QR Scanner shows placeholder message (not fully implemented)
- Export functionality returns dummy URLs
- Some screens show "coming soon" messages for incomplete features

## 📞 Support
For issues or questions, please check the code documentation or create an issue in the repository.

---

**Note**: This is a simplified version without offline sync, push notifications, and real payment integration. The application demonstrates core SHG management functionality with dummy implementations for advanced features.
