import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupport extends StatelessWidget {
  const ContactSupport({super.key});

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri telUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> _launchEmail(String emailAddress) async {
    final Uri emailUri = Uri.parse('mailto:$emailAddress');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailAddress';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Lighter, more modern background
      appBar: AppBar(
        backgroundColor: Colors.green[700], // Darker shade for better contrast
        title: const Text(
          "Contact Support",
          style: TextStyle(
            color: Colors.white, // White text for better readability
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 2, // Subtle shadow for depth
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.support_agent,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              "We're Here to Help",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Our support team is available to assist you with any questions or concerns",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),
            _buildContactCard(
              icon: Icons.phone,
              title: "Call Us",
              subtitle: "+91 1234567890",
              onTap: () => _launchPhoneCall("+911234567890"),
            ),
            const SizedBox(height: 20),
            _buildContactCard(
              icon: Icons.email,
              title: "Email Us",
              subtitle: "support@company.com", // More professional email
              onTap: () => _launchEmail("support@company.com"),
            ),
            const SizedBox(height: 30),
            const Text(
              "Business Hours: Mon-Fri, 9AM-6PM IST",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: Colors.green),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }
}