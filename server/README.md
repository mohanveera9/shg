# SHG Management Backend

Node.js + Express backend API for the SHG Management Application.

## Setup

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (local or Atlas)

### Installation

1. Install dependencies:
```bash
npm install
```

2. Configure environment variables:
   - Copy `.env.example` or create `.env`:
```bash
MONGODB_URI=mongodb://localhost:27017/shg_app
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRE=7d
REFRESH_TOKEN_SECRET=your_refresh_token_secret
PORT=3000
NODE_ENV=development
```

3. Start MongoDB:
```bash
mongod
```

4. Start the server:
```bash
npm start
```

For development with auto-reload:
```bash
npm run dev
```

The server will run on `http://localhost:3000`

## API Endpoints

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

### Other Endpoints
- Transactions, Loans, Products, Orders, Users, Reports, etc.

## Models

- **User** - User account information
- **OTP** - One-Time Password storage
- **Group** - SHG group information
- **Transaction** - Financial transactions
- **Loan** - Loan requests and repayments
- **Product** - Group products
- **Order** - Product orders

## Features

- JWT-based authentication
- OTP verification (6-digit, 10-minute expiry)
- Group management with unique codes
- QR code generation for groups
- Role-based access control
- All endpoints require authentication (except auth endpoints)

## Notes

- OTP is logged to console in development mode
- QR codes are generated as data URLs
- All dates are stored in UTC
- Passwords are hashed using bcrypt
