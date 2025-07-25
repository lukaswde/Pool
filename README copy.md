# Sports Club Point-of-Sale (POS) System

A Flutter-based self-service point-of-sale solution designed for sports clubs. This application allows users to authenticate using RFID chips, scan items with barcodes, and process their purchases independently.

## Features

### 🔐 RFID Authentication
- Users log in by scanning their RFID chip
- Secure user identification and welcome message
- Automatic cart clearing when switching users
- Logout functionality

### 📱 User Interface
- **Left Panel**: Sales history table showing recent transactions
  - Item descriptions
  - Customer usernames  
  - Purchase prices
  - Transaction timestamps
- **Right Panel**: User information and shopping cart
  - Welcome message with current user's name
  - Real-time shopping cart with item management
  - Quantity adjustment controls
  - Item removal functionality

### 🛒 Shopping Cart Features
- Add items by scanning barcodes
- Adjust item quantities with +/- buttons
- Remove individual items
- Real-time total calculation
- Process order with single button

### 🏪 Product Management
- Comprehensive product database
- Barcode scanning simulation
- Real-time inventory display
- Price calculation and display

## Demo Features

Since this is a demonstration app, it includes simulation buttons for:
- **RFID Scanning**: Cycles through test users
- **Barcode Scanning**: Adds random products to cart

Test users available:
- John Doe (RFID001)
- Jane Smith (RFID002)
- Mike Johnson (RFID003)
- Sarah Wilson (RFID004)
- Tom Brown (RFID005)

Available products:
- Energy drinks
- Protein bars
- Sports water
- Isotonic drinks
- Protein shakes
- Energy bars
- Fresh fruits

## Technical Implementation

### Architecture
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Material Design 3**: Modern UI components
- **State Management**: StatefulWidget with setState

### Key Components
- `LoginScreen`: RFID authentication interface
- `POSScreen`: Main point-of-sale interface  
- `UserInfoWidget`: Current user display
- `ShoppingCartWidget`: Cart management
- `SalesHistoryWidget`: Transaction history
- `POSService`: Backend simulation service

### Models
- `User`: User account information
- `Product`: Product catalog data
- `CartItem`: Shopping cart entries
- `Sale`: Transaction records

## Getting Started

### Prerequisites
- Flutter SDK (3.5.3 or later)
- Dart SDK
- Chrome browser (for web testing)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd pool_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

4. Select Chrome when prompted for the target device.

### Usage

1. **Login**: Click "Simulate RFID Scan" to authenticate as a test user
2. **Shopping**: Use "Simulate Barcode Scan" to add items to your cart
3. **Cart Management**: Adjust quantities or remove items as needed
4. **Checkout**: Click "Process Order" to complete the purchase
5. **User Switching**: Use the RFID scan button to switch between users
6. **Logout**: Click the logout button in the app bar

## Real-World Integration

For production use, this app would integrate with:

### Hardware
- RFID scanner for user authentication
- Barcode scanner for product identification
- Touch screen display
- Receipt printer
- Payment terminal

### Backend Services
- User management system
- Product inventory database
- Payment processing gateway
- Transaction logging
- Real-time synchronization

### Additional Features
- Network connectivity handling
- Offline mode support
- Admin panel for management
- Reporting and analytics
- Multi-language support

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── product.dart
│   ├── cart_item.dart
│   └── sale.dart
├── screens/                  # App screens
│   ├── login_screen.dart
│   └── pos_screen.dart
├── widgets/                  # Reusable components
│   ├── user_info_widget.dart
│   ├── shopping_cart_widget.dart
│   └── sales_history_widget.dart
└── services/                 # Business logic
    └── pos_service.dart
```

## Dependencies

- `flutter`: UI framework
- `intl`: Internationalization and date formatting
- `cupertino_icons`: iOS-style icons

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is designed for educational and demonstration purposes.

## Support

For questions or support, please contact the development team.
