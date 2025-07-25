import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/pos_screen.dart';
import 'screens/admin_screen.dart';
import 'models/user.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD1ybXafQ-vbwlMJTnnO-35fKJNJJ5DqXc",
        authDomain: "club-service-161d5.firebaseapp.com",
        projectId: "club-service-161d5",
        storageBucket: "club-service-161d5.firebasestorage.app",
        messagingSenderId: "857275839651",
        appId: "1:857275839651:web:b5873efd7ff916ffd83b16"),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseService _firebaseService = FirebaseService();
  User? _currentUser;
  bool _isInitialized = false;
  bool _showAdminPanel = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseData();
  }

  Future<void> _initializeFirebaseData() async {
    try {
      print('Starting Firebase data initialization...');
      // Initialize sample data in Firebase (only run this once)
      await _firebaseService.initializeSampleData();
      print('Firebase data initialization completed');
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing Firebase data: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase initialization failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      setState(() {
        _isInitialized = true; // Continue even if initialization fails
      });
    }
  }

  void _onUserAuthenticated(User user) {
    setState(() {
      _currentUser = user;
    });
  }

  void _onUserLogout() {
    setState(() {
      _currentUser = null;
    });
  }

  void _onAdminAccess() {
    setState(() {
      _showAdminPanel = true;
    });
  }

  void _onAdminExit() {
    setState(() {
      _showAdminPanel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        title: 'Sports Club POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initializing Firebase...'),
                SizedBox(height: 8),
                Text(
                  'Setting up sample data in Firestore database',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Text(
                  'If this takes too long, check Firebase Console\nfor Firestore security rules configuration',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Sports Club POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: _showAdminPanel
          ? AdminScreen(onLogout: _onAdminExit)
          : POSScreen(
              currentUser: _currentUser,
              onLogout: _onUserLogout,
              onUserAuthenticated: _onUserAuthenticated,
              onAdminAccess: _onAdminAccess,
            ),
    );
  }
}
