import 'package:flutter/material.dart';
import 'clinician_contact_screen.dart';

class CrisisAlertScreen extends StatelessWidget {
  const CrisisAlertScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> clinicianContacts = const [
    // Mangaluru
    {
      "name": "Mangalore Clinic",
      "address": "Market Rd, Hampankatta, Mangaluru",
      "phone": "08242440677",
      "email": "mangaloreclinic@example.com",
    },
    {
      "name": "Chitra Clinic",
      "address": "Balmatta Rd, Hampankatta, Mangaluru",
      "phone": "08242440550",
      "email": "chitraclinic@example.com",
    },
    {
      "name": "Aditya Multispeciality",
      "address": "Light House Hill Rd, Mangaluru",
      "phone": "08244272167",
      "email": "adityaclinic@example.com",
    },

    // Bangalore
    {
      "name": "Apollo Clinic – Indiranagar",
      "address": "100 Feet Rd, HAL 2nd Stage, Bengaluru",
      "phone": "18605007788",
      "email": "apolloindiranagar@example.com",
    },
    {
      "name": "Clinikk – Malleshwaram",
      "address": "Maruthi Ext., Malleshwaram, Bengaluru",
      "phone": "08068301324",
      "email": "clinikkmalleshwaram@example.com",
    },
    {
      "name": "Aditya Ayurvedic Clinic",
      "address": "19th Main Rd, Rajajinagar, Bengaluru",
      "phone": "09844680297",
      "email": "adityayurveda@example.com",
    },
    {
      "name": "Roy Health Clinic",
      "address": "SC Road, Gandhi Nagar, Bengaluru",
      "phone": "09349113791",
      "email": "royhealthclinic@example.com",
    },
  ];

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: const Text("Crisis Alert"),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
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
              "You're not alone. Choose a supportive action below:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon: const Icon(Icons.medical_services),
              label: const Text("Contact Clinician"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () => _showSnack(context, "Select a clinic below to contact directly"),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.phone_in_talk),
              label: const Text("Call Emergency Help"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => _showSnack(context, "Emergency help line activated 📞"),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              icon: const Icon(Icons.book_outlined),
              label: const Text("Open Journaling Support"),
              onPressed: () => _showSnack(context, "Guided journaling launched 📓"),
            ),

            const SizedBox(height: 32),
            const Text(
              "Nearby Clinicians 🩺",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: clinicianContacts.length,
                itemBuilder: (context, index) {
                  final clinic = clinicianContacts[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.local_hospital, color: Colors.teal),
                      title: Text(clinic["name"] ?? ""),
                      subtitle: Text(clinic["address"] ?? ""),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 18),
                      onTap: () {
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
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              "🌿 MindGuardian holds space for you. One gentle step at a time.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
