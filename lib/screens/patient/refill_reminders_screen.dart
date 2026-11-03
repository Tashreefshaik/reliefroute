import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/refill_reminder.dart';
import '../../services/firestore_service.dart';

class RefillRemindersScreen extends StatefulWidget {
  const RefillRemindersScreen({super.key});

  @override
  State<RefillRemindersScreen> createState() => _RefillRemindersScreenState();
}

class _RefillRemindersScreenState extends State<RefillRemindersScreen> {
  List<RefillReminder> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Get actual user ID from auth service
      final reminders = await context
          .read<FirestoreService>()
          .getUserReminders('demo_user_id');
      setState(() {
        _reminders = reminders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading reminders: $e')),
        );
      }
    }
  }

  Future<void> _toggleReminder(RefillReminder reminder) async {
    try {
      await context.read<FirestoreService>().updateReminderStatus(
            reminder.reminderId,
            !reminder.active,
          );
      _loadReminders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating reminder: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reminders.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.alarm_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No refill reminders set',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Set reminders to never miss a refill',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = _reminders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: SwitchListTile(
                        title: Text('Reminder #${reminder.reminderId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next reminder: ${reminder.reminderDate.toString().split('.')[0]}',
                            ),
                            Text('Frequency: ${reminder.frequency}'),
                          ],
                        ),
                        value: reminder.active,
                        onChanged: (value) => _toggleReminder(reminder),
                        secondary: Icon(
                          Icons.alarm,
                          color: reminder.active ? Colors.blue : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add reminder dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add reminder feature coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
