import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/firebase_service.dart';

class AdminUsersWidget extends StatefulWidget {
  final List<User> users;
  final VoidCallback onRefresh;

  const AdminUsersWidget({
    super.key,
    required this.users,
    required this.onRefresh,
  });

  @override
  State<AdminUsersWidget> createState() => _AdminUsersWidgetState();
}

class _AdminUsersWidgetState extends State<AdminUsersWidget> {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _addUser() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddUserDialog(),
    );

    if (result != null) {
      try {
        final newUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: result['name']!,
          rfidChip: result['rfidChip']!,
        );

        await _firebaseService.addUser(newUser);
        widget.onRefresh();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding user: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _firebaseService.deleteUser(user.id);
        widget.onRefresh();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting user: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Users (${widget.users.length})',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: _addUser,
                icon: const Icon(Icons.add),
                label: const Text('Add User'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: widget.users.isEmpty
                ? const Center(
                    child: Text('No users found'),
                  )
                : ListView.builder(
                    itemCount: widget.users.length,
                    itemBuilder: (context, index) {
                      final user = widget.users[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(user.name[0].toUpperCase()),
                          ),
                          title: Text(user.name),
                          subtitle: Text('RFID: ${user.rfidChip}'),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'delete') {
                                _deleteUser(user);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rfidController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _rfidController.dispose();
    super.dispose();
  }

  void _generateRfidChip() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _rfidController.text = 'RFID${timestamp.toString().substring(7)}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New User'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rfidController,
                    decoration: const InputDecoration(
                      labelText: 'RFID Chip ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an RFID chip ID';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _generateRfidChip,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Generate RFID',
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop({
                'name': _nameController.text.trim(),
                'rfidChip': _rfidController.text.trim(),
              });
            }
          },
          child: const Text('Add User'),
        ),
      ],
    );
  }
}
