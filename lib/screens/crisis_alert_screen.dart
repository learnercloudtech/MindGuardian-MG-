import 'package:flutter/material.dart';
import 'clinician_contact_screen.dart';

class CrisisAlertScreen extends StatelessWidget {
  const CrisisAlertScreen({super.key});

  final List<Map<String, String>> clinicianContacts = const [
    {
      "region": "Mangaluru",
      "name": "Mangalore Clinic",
      "address": "Market Rd, Hampankatta, Mangaluru",
      "phone": "08242440677",
      "email": "mangaloreclinic@example.com",
    },
    {
      "region": "Mangaluru",
      "name": "Chitra Clinic",
      "address": "Balmatta Rd, Hampankatta, Mangaluru",
      "phone": "08242440550",
      "email": "chitraclinic@example.com",
    },
    {
      "region": "Mangaluru",
      "name": "Aditya Multispeciality",
      "address": "Light House Hill Rd, Mangaluru",
      "phone": "08244272167",
      "email": "adityaclinic@example.com",
    },
    {
      "region": "Bangalore",
      "name": "Apollo Clinic – Indiranagar",
      "address": "100 Feet Rd, HAL 2nd Stage, Bengaluru",
      "phone": "18605007788",
      "email": "apolloindiranagar@example.com",
    },
    {
      "region": "Bangalore",
      "name": "Clinikk – Malleshwaram",
      "address": "Maruthi Ext., Malleshwaram, Bengaluru",
      "phone": "08068301324",
      "email": "clinikkmalleshwaram@example.com",
    },
    {
      "region": "Bangalore",
      "name": "Aditya Ayurvedic Clinic",
      "address": "19th Main Rd, Rajajinagar, Bengaluru",
      "phone": "09844680297",
      "email": "adityayurveda@example.com",
    },
    {
      "region": "Bangalore",
      "name": "Roy Health Clinic",
      "address": "SC Road, Gandhi Nagar, Bengaluru",
      "phone": "09349113791",
      "email": "royhealthclinic@example.com",
    },
  ];

  void _showClinicianList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a Clinician 🩺', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...clinicianContacts.map((clinic) => ListTile(
                leading: const Icon(Icons.local_hospital, color: Colors.teal),
                title: Text(clinic["name"]!),
                subtitle: Text(clinic["address"]!),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context); // Close modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClinicianContactScreen(
                        name: clinic["name"]!,
                        phone: clinic["phone"]!,
                        email: clinic["email"]!,
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text("Crisis Alert"),
        backgroundColor: theme.colorScheme.error,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "High Emotional Risk Detected ⚠️",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 12),
              const Text(
                "You're not alone. Choose one of the supportive actions:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.medical_services),
                label: const Text("Contact Clinician"),
                onPressed: () => _showClinicianList(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.phone_in_talk),
                label: const Text("Call Emergency Help"),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("📞 Emergency help line activated")),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.book_outlined),
                label: const Text("Open Journaling Support"),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("📓 Guided journaling launched")),
                ),
              ),
              const Spacer(),
              const Text(
                "🌿 MindGuardian holds space for you.\nOne gentle step at a time.",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
