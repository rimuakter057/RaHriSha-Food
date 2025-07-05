import 'package:flutter/material.dart';
import 'package:rahrisha_food/app/assets_path.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _feedbackTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Contact Us',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetsPath.contact, fit: BoxFit.contain),
            const SizedBox(height: 16),
            const Text(
              'Have a question or feedback?',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            const Text(
              '\nWe\'d love to hear from you!',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 32),
            _buildForm(),

            const SizedBox(height: 32),

            const Text(
              'Other ways to reach us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const Column(
              children: [
                Row(children: [Icon(Icons.email), Text('support@foodapp.com')]),
                const SizedBox(height: 16),
                Row(children: [Icon(Icons.phone), Text('1-800-3463-343')]),
                const SizedBox(height: 16),
                Row(children: [Icon(Icons.access_time), Text('Sat-Fri 24/7')]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameTEController,
            decoration: InputDecoration(
              hintText: 'Your Name',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
              ),
              prefixIcon: Icon(Icons.person),
              prefixIconColor: Colors.grey,

              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailTEController,
            decoration: InputDecoration(
              hintText: 'Your email address',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
              ),
              prefixIcon: Icon(Icons.email),
              prefixIconColor: Colors.grey,

              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            maxLines: 3,
            controller: _feedbackTEController,
            decoration: InputDecoration(
              hintText: 'Write your Feedback here',

              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
              ),
              prefixIcon: Icon(Icons.feedback_rounded),
              prefixIconColor: Colors.grey,

              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Write your feedback here';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          // Divider
          const Divider(thickness: 2),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white12,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Send Message',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
