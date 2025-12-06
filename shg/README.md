# SHG Mobile App

Flutter mobile application for Self-Help Group management.

## Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Update API base URL in `lib/config/config.dart`:
   - Android Emulator: `http://10.0.2.2:3000/api`
   - iOS Simulator: `http://localhost:3000/api`
   - Physical Device: `http://YOUR_COMPUTER_IP:3000/api`

3. Run the app:
```bash
flutter run
```

## Features

- Phone-based authentication with OTP
- Multi-language support (Telugu, English)
- Group creation and joining via QR code
- Role-based dashboard
- Bookkeeping and transactions
- Savings management
- Loan management
- Marketplace (products and orders)
- Reports and analytics

## Project Structure

```
lib/
├── config/          # App configuration
├── models/          # Data models
├── providers/       # State management (Provider)
├── screens/         # UI screens
├── services/        # API and storage services
└── utils/           # Helper functions
```

## Development Notes

- Uses Provider for state management
- Secure storage for authentication tokens
- Shared preferences for app settings
- Material Design 3 UI
- Localization support for Telugu and English

