import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/medicine_reminder_service.dart';
import '../models/caretakee_profile.dart';
import '../models/medicine_reminder.dart';
import '../widgets/medicine_reminder_card.dart';
import 'add_medicine_reminder_screen.dart';

class HomeScreen extends StatefulWidget {
  final CaretakeeProfile? selectedProfile;

  const HomeScreen({super.key, this.selectedProfile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MedicineReminderService _medicineReminderService =
      MedicineReminderService();
  List<MedicineReminder> _medicineReminders = [];
  bool _isLoadingReminders = false;

  @override
  void initState() {
    super.initState();
    _loadMedicineReminders();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedProfile?.id != widget.selectedProfile?.id) {
      _loadMedicineReminders();
    }
  }

  Future<void> _loadMedicineReminders() async {
    if (widget.selectedProfile == null) {
      setState(() {
        _medicineReminders = [];
      });
      return;
    }

    setState(() {
      _isLoadingReminders = true;
    });

    try {
      // First test Firestore connection
      print('Testing Firestore connection...');
      await _medicineReminderService.testFirestoreConnection();

      print(
        'Loading medicine reminders for profile: ${widget.selectedProfile!.id}',
      );
      final reminders = await _medicineReminderService.getMedicineReminders(
        widget.selectedProfile!.id,
      );

      print('Successfully loaded ${reminders.length} reminders');
      setState(() {
        _medicineReminders = reminders;
      });
    } catch (e) {
      print('Error in _loadMedicineReminders: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading reminders: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingReminders = false;
      });
    }
  }

  Future<void> _navigateToAddReminder() async {
    if (widget.selectedProfile == null) return;

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) =>
            AddMedicineReminderScreen(profile: widget.selectedProfile!),
      ),
    );

    if (result == true) {
      _loadMedicineReminders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final User? user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade200,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (widget.selectedProfile != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: Text(
                      widget.selectedProfile!.name
                          .substring(0, 1)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/profiles');
                    },
                    child: Text(
                      widget.selectedProfile!.name.split(
                        ' ',
                      )[0], // First name only
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple.shade50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.health_and_safety,
                    size: 40,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Caregiver App',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Logged in as: ${user?.phoneNumber ?? 'Unknown'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            if (widget.selectedProfile != null)
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Switch Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacementNamed('/profiles');
                },
              ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon!')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await authService.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ],
        ),
      ),
      // Main content
      body: Padding(padding: const EdgeInsets.all(24.0), child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (widget.selectedProfile == null) {
      return const Center(
        child: Text(
          'Please select a profile to continue',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    if (_isLoadingReminders) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_medicineReminders.isEmpty) {
      return _buildWelcomeCard();
    }

    return _buildMedicineRemindersList();
  }

  Widget _buildWelcomeCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Your caregiving journey starts here',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Manage care tasks and activities for ${widget.selectedProfile!.name}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _navigateToAddReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Medicine Reminder'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineRemindersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Medicine Reminders for ${widget.selectedProfile!.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: _navigateToAddReminder,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _medicineReminders.length,
            itemBuilder: (context, index) {
              return MedicineReminderCard(
                reminder: _medicineReminders[index],
                onTap: () {
                  // TODO: Navigate to medicine reminder details screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reminder details coming soon!'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
