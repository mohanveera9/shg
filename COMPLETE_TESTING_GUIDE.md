# Complete Testing Guide - SHG Management App

## Prerequisites Setup

### 1. Install MongoDB

**macOS (using Homebrew):**
```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

**Ubuntu/Linux:**
```bash
sudo apt-get install -y mongodb
sudo systemctl start mongodb
```

**Windows:**
Download from: https://www.mongodb.com/try/download/community
Or use: `choco install mongodb`

### 2. Verify MongoDB is Running

```bash
mongo --version
mongosh  # Should connect to local MongoDB
```

## Backend Setup

### 1. Install Dependencies

```bash
cd /home/engine/project/server
npm install
```

This will install:
- express
- mongoose
- bcrypt (password hashing)
- jsonwebtoken (JWT auth)
- nanoid (unique IDs)
- cors (cross-origin)
- dotenv (environment config)
- multer (file upload)
- qrcode (QR generation)

### 2. Configure Environment (Optional)

The `.env` file is already configured with default values:
```
MONGODB_URI=mongodb://localhost:27017/shg_app
JWT_SECRET=your_jwt_secret_key_change_in_production
JWT_EXPIRE=7d
REFRESH_TOKEN_SECRET=your_refresh_token_secret_change_in_production
PORT=3000
NODE_ENV=development
```

For production, update these values.

### 3. Start the Server

```bash
cd /home/engine/project/server
npm start
```

You should see:
```
MongoDB connected successfully
Server running on port 3000
```

The API will be available at: `http://localhost:3000/api`

## Frontend Setup

### 1. Install Dependencies

```bash
cd /home/engine/project/shg
flutter pub get
```

### 2. Generate Localization

```bash
flutter gen-l10n
```

### 3. Run the App

For Android:
```bash
flutter run
```

For iOS:
```bash
flutter run -d ios
```

For Web:
```bash
flutter run -d chrome
```

## Testing the Complete Flow

### Test 1: OTP Generation (NOT Hardcoded)

**Objective:** Verify OTP is randomly generated, not hardcoded

**Steps:**
1. Start the backend server
2. Check server console logs
3. Send OTP requests multiple times
4. Verify each OTP is different

**Expected:**
```
OTP for +919876543210: 245789
OTP for +919876543210: 812634
OTP for +919876543210: 567234
```

Each OTP should be different and random.

### Test 2: Authentication Flow

**In the App:**

1. **Select Language** - Choose English or Telugu

2. **Grant Permissions** - Allow camera and storage

3. **Phone Input** - Enter any 10-digit number (e.g., 9876543210)

4. **OTP Verification** 
   - Check server console for the generated OTP
   - Enter the OTP shown in console
   - App should navigate to group selection screen

**Expected Result:** Successfully logged in, redirected to group selection

### Test 3: Create Group (with QR Code)

**Steps:**
1. After login, tap "Create New Group"
2. Fill in details:
   - Group Name: "Test SHG"
   - Village: "Test Village"
   - Block: "Test Block"
   - District: "Test District"
   - Research Consent: Toggle to ON/OFF
3. Tap "Create Group"

**Expected Result:**
- ✅ Loading indicator shows
- ✅ Redirects to "Group Created" screen
- ✅ Shows group code (8 characters, uppercase)
- ✅ Shows QR code image
- ✅ Shows "Share Group Details" button
- ✅ Shows "Go to Dashboard" button

**Verify in Database:**
```bash
# In mongosh terminal:
use shg_app
db.groups.findOne()

# Should show:
{
  "_id": ObjectId(...),
  "name": "Test SHG",
  "groupCode": "ABC12345",
  "groupId": "grp_...",
  "qrCode": "data:image/png;base64,...",
  "village": "Test Village",
  ...
}
```

### Test 4: Dashboard

**Steps:**
1. From "Group Created" screen, tap "Go to Dashboard"
2. View dashboard with:
   - Cash in Hand
   - Group Savings
   - Due Loans
   - Today's Tasks

**Expected Result:** Dashboard loads with data

### Test 5: Join Group (with QR Scanning)

**Setup:**
1. Create a second user/phone
2. Go through login flow again

**Steps:**
1. At group selection, tap "Join Existing Group"
2. Option A: Enter group code manually
   - Type the 8-character code from previous group
   - Tap "Join Group"
3. Option B: Scan QR code (Requires physical device/emulator)
   - Tap "Scan QR Code"
   - Camera opens
   - Point at generated QR code
   - Code auto-fills

**Expected Result:**
- ✅ Successfully joined the existing group
- ✅ Redirected to dashboard
- ✅ User appears in group members

### Test 6: Field Mismatch Verification

**Backend Response Check:**

1. Create a group and capture API response
2. Verify these fields exist:
   - `id` (MongoDB ObjectId)
   - `name`
   - `groupCode` (8-char)
   - `groupId` (unique)
   - `qrCode` (data URL)
   - `village`, `block`, `district`
   - `members` (array)
   - `totalMembers`
   - `cashInHand`
   - `totalSavings`
   - `researchConsent`

3. Verify User response includes:
   - `id`
   - `phone`
   - `name`
   - `email`
   - `profilePhoto`
   - `role` (MEMBER, TREASURER, etc.)

### Test 7: Error Handling

**Test Invalid Code:**
1. Go to join group
2. Enter invalid code (e.g., "INVALID12")
3. Tap join

**Expected:** Error message: "Group not found"

**Test Already Member:**
1. Create a group
2. Without logout, go to join group
3. Enter same group code

**Expected:** Error message: "You are already a member of this group"

**Test OTP Expired:**
1. Request OTP
2. Wait 10+ minutes
3. Try to verify old OTP

**Expected:** Error message: "OTP has expired"

**Test Invalid OTP:**
1. Enter wrong OTP 3 times

**Expected:** Error message: "Too many attempts. Please request a new OTP"

### Test 8: Localization

**English:**
1. Select "English" at language selection
2. Verify all strings are in English

**Telugu:**
1. Create another profile
2. Select "తెలుగు" at language selection
3. Verify all strings are in Telugu

**Key Terms to Check:**
- Group Created = సమూహం సృష్టించబడింది
- Go to Dashboard = డ్యాష్‌బోర్డుకు వెళ్లండి
- Join Group = సమూహంలో చేరండి
- Create Group = సమూహాన్ని సృష్టించండి

## API Testing with cURL

### Send OTP
```bash
curl -X POST http://localhost:3000/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phone": "+919876543210"}'
```

Response:
```json
{
  "success": true,
  "message": "OTP sent successfully",
  "otp": "123456"
}
```

### Verify OTP
```bash
curl -X POST http://localhost:3000/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phone": "+919876543210", "otp": "123456"}'
```

Response:
```json
{
  "success": true,
  "accessToken": "jwt_token_here",
  "refreshToken": "refresh_token_here",
  "user": {
    "id": "user_id",
    "phone": "+919876543210",
    "name": "",
    "role": "MEMBER"
  }
}
```

### Create Group
```bash
TOKEN="your_access_token"
curl -X POST http://localhost:3000/api/groups/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Test Group",
    "village": "Village",
    "block": "Block",
    "district": "District",
    "researchConsent": false
  }'
```

### Join Group
```bash
curl -X POST http://localhost:3000/api/groups/join \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"groupCode": "ABC12345"}'
```

## Debugging Tips

### Backend Issues

**Port Already in Use:**
```bash
# Find process using port 3000
lsof -i :3000

# Kill the process
kill -9 <PID>
```

**MongoDB Connection Issues:**
```bash
# Check if MongoDB is running
mongosh

# Check connection string in .env
```

**Missing Dependencies:**
```bash
# Reinstall packages
rm -rf node_modules
npm install
```

### Frontend Issues

**Dart/Flutter Errors:**
```bash
# Clean build
flutter clean

# Get dependencies again
flutter pub get

# Analyze code
flutter analyze
```

**API Connection Issues:**
- Verify backend is running
- Check API URL in `app_config.dart`
- Use DevTools to inspect network requests

## Performance Testing

### Load Testing OTP Generation
```bash
# Generate 100 OTPs to verify randomness
for i in {1..100}; do
  curl -X POST http://localhost:3000/api/auth/send-otp \
    -H "Content-Type: application/json" \
    -d "{\"phone\": \"+91987654321$i\"}"
done
```

### Verify Unique Group Codes
```bash
# Check all group codes are unique
mongosh
use shg_app
db.groups.aggregate([
  {
    $group: {
      _id: "$groupCode",
      count: { $sum: 1 }
    }
  },
  {
    $match: { count: { $gt: 1 } }
  }
])
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Cannot connect to MongoDB" | Start MongoDB service: `brew services start mongodb-community` |
| "Port 3000 already in use" | Kill process: `lsof -i :3000` then `kill -9 <PID>` |
| "OTP always 123456" | Backend not running or using old code |
| "QR code not showing" | Verify qrcode npm package installed: `npm ls qrcode` |
| "App can't connect to API" | Check apiBaseUrl in app_config.dart matches server address |
| "Group code is lowercase" | Backend generating correctly, check frontend uppercase() call |
| "OTP expires too quickly" | Check expiry time in backend (should be 10 minutes) |

## Success Indicators

After completing all tests, you should have:

✅ Random OTP generation (not 123456)
✅ OTP expiry working (10 minutes)
✅ OTP attempt limit (3 tries)
✅ Group creation with unique code
✅ QR code generation and display
✅ QR code scanning functionality
✅ Group joining with code
✅ Field mapping correct (no mismatches)
✅ Localization working (EN/TE)
✅ Error handling working
✅ Dashboard displaying correctly

## Next Steps

After successful testing:
1. Deploy backend to production server
2. Update apiBaseUrl in app_config.dart to production URL
3. Generate production builds (APK/IPA)
4. Test on actual devices
5. Deploy to Play Store/App Store
6. Set up SMS/WhatsApp integration for OTP
7. Implement real payment gateway

## Support

For issues during testing:
1. Check server console for errors
2. Check app console for API errors
3. Review logs in MongoDB
4. Check network requests in browser DevTools
5. Refer to TICKET_IMPLEMENTATION.md for detailed info
