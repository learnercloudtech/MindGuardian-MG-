import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicianContactScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String email;

  const ClinicianContactScreen({
    this.name = 'Clinician',
    this.phone = '',
    this.email = '',
    super.key,
  });

  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("🚫 Cannot launch phone: $phone");
    }
  }

  Future<void> _launchSMS(String phone) async {
    final uri = Uri.parse("sms:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("🚫 Cannot send SMS to: $phone");
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse("mailto:$email");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("🚫 Cannot send email to: $email");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isValidPhone = phone.isNotEmpty;
    final isValidEmail = email.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Support'),
        backgroundColor: theme.colorScheme.error,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (isValidPhone)
              ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text('Call Clinician'),
                onPressed: () => _launchPhone(phone),
              ),
            if (isValidPhone)
              ElevatedButton.icon(
                icon: const Icon(Icons.message),
                label: const Text('Send SMS'),
                onPressed: () => _launchSMS(phone),
              ),
            if (isValidEmail)
              ElevatedButton.icon(
                icon: const Icon(Icons.email),
                label: const Text('Email Support'),
                onPressed: () => _launchEmail(email),
              ),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to MindGuardian'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
