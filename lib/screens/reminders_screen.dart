import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final titleCtrl = TextEditingController();
  DateTime? selectedDate;
  bool saving = false;

  Future<void> _addReminder() async {
    if (selectedDate == null || titleCtrl.text.trim().isEmpty) return;
    setState(() => saving = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('reminders').add({
        'title': titleCtrl.text.trim(),
        'date': Timestamp.fromDate(selectedDate!),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // immediate test notification (you can replace with scheduled logic later)
      await NotificationService().showNow('Reminder set', titleCtrl.text.trim());

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Reminder Title')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(now.year, now.month, now.day),
                  lastDate: DateTime(now.year + 3),
                  initialDate: now,
                );
                if (date != null) {
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (time != null) {
                    setState(() => selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute));
                  }
                }
              },
              child: Text(selectedDate == null ? 'Pick Date & Time' : selectedDate.toString()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saving ? null : _addReminder, child: saving ? const CircularProgressIndicator() : const Text('Save Reminder')),
          ],
        ),
      ),
    );
  }
}
