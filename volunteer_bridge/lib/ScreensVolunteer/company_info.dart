import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For SVG icons if needed
import 'package:url_launcher/url_launcher.dart'; // For launching links

void main() {
  runApp(const ProviderScope(
      child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AboutUsPage(),
  )));
}

class AboutUsPage extends StatelessWidget {
  final Color purple = const Color(0xFFEDE1F8);

  const AboutUsPage({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SvgPicture.asset(
            'assets/Handshake.svg',
            height: 50,
            width: 50,
          ),
        ),
        title: const Text(
          "Volunteer Bridge",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: const Text(
                    '5',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              "About us",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    "Hearts United",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const InfoRow(
                      icon: Icons.location_on,
                      text:
                          "456 Sampaguita Street Barangay San Isidro Quezon City, Metro Manila 1100, Philippines"),
                  const InfoRow(
                      icon: Icons.calendar_today, text: "October 25, 2098"),
                  const InfoRow(icon: Icons.phone, text: "09785603941"),
                  const InfoRow(
                      icon: Icons.email, text: "contact@heartsunited.org"),
                  const InfoRow(
                      icon: Icons.language, text: "www.heartsunited.org"),
                  const SizedBox(height: 16),
                  const SectionHeader("Who We Are"),
                  const Text(
                    "At Hearts United, we believe that compassion is a powerful force for change. Founded in 2018, our organization is built on the simple yet profound idea that communities thrive when people come together for a common purpose. We are a passionate team of organizers, advocates, and everyday citizens committed to making a lasting impact through volunteerism.",
                  ),
                  const SizedBox(height: 12),
                  const SectionHeader("Our Mission"),
                  const Text(
                    "To unite hearts through community-driven volunteer events that uplift lives, promote kindness, and foster social responsibility. We aim to create meaningful opportunities where people can give back, connect, and be part of something greater than themselves.",
                  ),
                  const SizedBox(height: 12),
                  const SectionHeader("Join Us"),
                  GestureDetector(
                    onTap: () => _launchURL("https://www.heartsunited.org"),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text:
                                "Whether you're an individual looking to make a difference, or an organization wanting to collaborate, Hearts United welcomes you. Together, we can build a stronger, more compassionate community—one volunteer event at a time. ",
                          ),
                          TextSpan(
                            text: "www.heartsunited.org",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                          TextSpan(text: " | "),
                          TextSpan(
                            text: "contact@heartsunited.org",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                          TextSpan(text: " | 📍 Based in Metro City, USA"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
