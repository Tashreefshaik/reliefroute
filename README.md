# ReliefRoute

A cross-platform Flutter medication ordering and delivery platform for patients who may struggle with pharmacy or clinic queues, repeated trips, transportation limitations, mobility barriers, age, chronic illness, or physical disability.

## Features

### Patient Features
- **Medication Browsing** - Browse and search medications with detailed information
- **Prescription Management** - Upload and manage prescriptions
- **Order Tracking** - Real-time GPS tracking of medication deliveries
- **Cart & Checkout** - Add medications to cart and checkout with payment details
- **Order History** - View past and current orders
- **Refill Reminders** - Set up medication refill reminders
- **Favorites** - Save frequently ordered medications

### Pharmacist Features
- **Prescription Verification** - Review and approve/reject prescriptions
- **Order Management** - Manage incoming medication orders
- **Delivery Tracking** - Monitor active deliveries with GPS
- **Inventory Management** - Manage medication stock

### Driver Features
- **Delivery Management** - View assigned deliveries
- **GPS Navigation** - Navigate to delivery locations
- **Status Updates** - Update delivery status (picked up, in transit, delivered)

### Admin Features
- **User Management** - Manage all users in the system
- **Medication Management** - Add, edit, and remove medications
- **Order Monitoring** - View all orders across the system
- **Analytics** - View delivery and usage statistics

## Technology Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Database**: Firebase Cloud Firestore (planned)
- **Authentication**: Firebase Auth (planned)
- **Storage**: Firebase Storage (planned)
- **Maps**: flutter_map with OpenStreetMap tiles
- **GPS**: Simulated GPS service for tracking

## Getting Started

### Prerequisites
- Flutter SDK (3.47.7 or higher)
- Dart SDK (3.13.5 or higher)
- Android Studio / Xcode (for mobile development)
- Visual Studio (for Windows development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/reliefroute.git
cd reliefroute
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For Windows
flutter run -d windows

# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

## Current Status

The app is currently in development with the following features implemented:

✅ **Completed**
- Patient, Pharmacist, Driver, and Admin role-based authentication
- Medication browsing with images and details
- Cart and checkout functionality
- Mock order management
- GPS tracking system with simulated data
- Professional UI with ReliefRoute branding
- South African Rand (ZAR) currency support
- Card payment form in checkout

🚧 **In Progress**
- Firebase integration for production backend
- Real GPS tracking integration
- Prescription image upload

📋 **Planned**
- Push notifications
- Real-time order updates
- Payment gateway integration
- Prescription image upload
- Delivery route optimization

## Design

The app uses the ReliefRoute brand colors:
- **Teal**: #087F8C
- **Navy**: #123047
- **Mint**: #E5F6F2
- **Canvas**: #F6F8FA
- **Ink**: #1F2937
- **Muted**: #64748B

## License

This project is licensed under the MIT License.

## Contact

For questions or support, please contact the development team.
