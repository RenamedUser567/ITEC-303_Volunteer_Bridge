import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: LandingPage(),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Are you an Organizer or a Volunteer?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset('assets/Organizer_landing.svg',
                      height: 100, width: 100),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 155, 93, 229),
                    ),
                    child: const Text(
                      'Organizer',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                children: [
                  SvgPicture.asset('assets/Volunteer_landing.svg',
                      height: 100, width: 100),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 155, 93, 229),
                    ),
                    child: const Text(
                      'Volunteer',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Already have an account? ',
            style: TextStyle(fontSize: 20),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to Login Page (implement navigation here)
            },
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 155, 93, 229),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
