import 'package:flutter/material.dart';
import 'home_page.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.contact_mail, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              const Text(
                'Email: support@travelapp.com',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'Phone: +977-9879863214',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),

              // Social icons
              const Text(
                'Connect with us:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.purple),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat, color: Colors.lightBlue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.email, color: Colors.redAccent),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Divider(thickness: 1.5),
              const SizedBox(height: 20),

              const Text(
                'Terms & Conditions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'By using our services, you agree to the terms of service including data protection, privacy policy, and responsible usage. Please read our full policy on our official site.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
