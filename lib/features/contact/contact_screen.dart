import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactFab extends StatelessWidget {
  const ContactFab({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Colors.white,
      overlayOpacity: 0.3,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.phone, color: Colors.white),
          backgroundColor: Colors.green.shade700,
          onTap: () => _launchUrl('tel:+8801613475871'),
        ),
        SpeedDialChild(
          child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
          backgroundColor: Colors.green.shade800,
          onTap: () {
            final phone = '8801613475871';
            final text = Uri.encodeComponent("Hello, I want to contact you!");
            _launchUrl('https://wa.me/$phone?text=$text');
          },
        ),
        SpeedDialChild(
          child: const FaIcon(FontAwesomeIcons.facebookMessenger, color: Colors.white),
          backgroundColor: Colors.blue.shade700,
          onTap: () {
            final username = 'md.rana.sheikh.598370';
            _launchUrl('https://m.me/$username');
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.email_outlined, color: Colors.white),
          backgroundColor: Colors.red.shade600,
          onTap: () {
            final email = 'rana6424sheikh@gmail.com';
            final subject = Uri.encodeComponent("Inquiry from App");
            final body = Uri.encodeComponent("Hello, I would like to...");
            _launchUrl('mailto:$email?subject=$subject&body=$body');
          },
        ),
      ],
      child: Container(
        height: 56,
        width: 56,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.amber,
            width: 1,
          ),
        ),
        child: Lottie.asset(
          'assets/images/home/Customer Support.json',
          repeat: true,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
