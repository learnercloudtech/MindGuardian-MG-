import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicianContactScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String email;

  const ClinicianContactScreen({
    required this.name,
    required this.phone,
    required this.email,
    Key? key,
  }) : super(key: key);

  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchSMS(String phone) async {
    final uri = Uri.parse("sms:$phone");
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse("mailto:$email");
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Support'),
        backgroundColor: theme.colorScheme.error,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Contact $name 💙',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Reach out using the method that feels right:',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.phone),
              label: const Text('Call Clinician'),
              onPressed: () => _launchPhone(phone),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.message),
              label: const Text('Send SMS'),
              onPressed: () => _launchSMS(phone),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('Email Support'),
              onPressed: () => _launchEmail(email),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to MindGuardian'),
            ),
          ],
        ),
      ),
    );
  }
}
