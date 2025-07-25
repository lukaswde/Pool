import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/pos_service.dart';

class LoginScreen extends StatefulWidget {
  final Function(User) onUserAuthenticated;

  const LoginScreen({
    super.key,
    required this.onUserAuthenticated,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final POSService _posService = POSService();
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  void _simulateRFIDScan() async {
    setState(() {
      _isScanning = true;
    });

    _scanAnimationController.repeat();

    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));

    // Get a random user for demonstration
    final users = _posService.getAllUsers();
    final randomUser = users[DateTime.now().millisecond % users.length];

    _scanAnimationController.stop();
    _scanAnimationController.reset();

    setState(() {
      _isScanning = false;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome ${randomUser.name}!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Authenticate user
      widget.onUserAuthenticated(randomUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Club POS - Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // RFID scanner icon with animation
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isScanning
                          ? Colors.blue.withOpacity(_scanAnimation.value)
                          : Colors.grey,
                      width: 4,
                    ),
                  ),
                  child: Icon(
                    Icons.nfc,
                    size: 100,
                    color: _isScanning
                        ? Colors.blue
                            .withOpacity(0.7 + _scanAnimation.value * 0.3)
                        : Colors.grey,
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Instructions
            Text(
              _isScanning
                  ? 'Scanning RFID chip...'
                  : 'Place your RFID chip near the scanner',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _isScanning ? Colors.blue : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            if (!_isScanning)
              Text(
                'Tap the button below to simulate RFID scanning',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 40),

            // Simulate scan button
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _simulateRFIDScan,
              icon: Icon(_isScanning ? Icons.hourglass_empty : Icons.nfc),
              label: Text(_isScanning ? 'Scanning...' : 'Simulate RFID Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Available users for testing
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Available Test Users:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ..._posService.getAllUsers().map((user) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(user.name),
                            Text(
                              user.rfidChip,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
