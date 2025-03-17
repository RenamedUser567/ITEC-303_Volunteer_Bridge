import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const SignUpPage());
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centering the title properly
              const SizedBox(
                height: 100.0,
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/Handshake.svg',
                        height: 40, width: 40),
                    const SizedBox(height: 8.0),
                    const Text(
                      '  Create an Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24.0),

              // First Name Input
              const TextField(
                decoration: InputDecoration(
                  labelText: 'What is your first name?',
                  filled: true,
                  fillColor: Color.fromARGB(255, 239, 236, 239),
                ),
              ),
              const SizedBox(height: 16.0),

              // Last Name Input
              const TextField(
                decoration: InputDecoration(
                  labelText: 'What is your last name?',
                  filled: true,
                  fillColor: Color.fromARGB(255, 239, 236, 239),
                ),
              ),
              const SizedBox(height: 16.0),

              // Date of Birth Input
              const TextField(
                decoration: InputDecoration(
                  labelText: 'What is your date of birth?',
                  suffixIcon: Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Color.fromARGB(255, 239, 236, 239),
                ),
              ),
              const SizedBox(height: 16.0),

              // Phone Number Input
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  filled: true,
                  fillColor: Color.fromARGB(255, 239, 236, 239),
                ),
              ),
              const SizedBox(height: 16.0),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select your gender',
                  filled: true,
                  fillColor: Color.fromARGB(255, 239, 236, 239),
                ),
                items: <String>['Male', 'Female', 'Others'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
              ),
              const SizedBox(height: 16.0),

              // Email Input
              const TextField(
                decoration: InputDecoration(
                  labelText: 'What is your email?',
                  filled: true,
                  fillColor: Color.fromARGB(255, 239, 236, 239),
                ),
              ),
              const SizedBox(height: 32.0),

              // Full-width Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle continue action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 155, 93, 229),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Already have an account text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle login action
                    },
                    child: const Text('Login', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
