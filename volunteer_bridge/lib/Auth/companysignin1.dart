import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:volunteer_bridge/Auth/companysignin2.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';

class CompanyInfoStep1 extends ConsumerWidget {
  CompanyInfoStep1({super.key});

  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _locationController = TextEditingController();
  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goToNext(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CompanyInfoStep2(),
        ),
      );
    }

    final organizerSignUp = ref.read(organizerSignUpProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey2,
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/Handshake.svg', // Ensure the path is correct
                    height: 50, // Adjust the height as needed
                    width: 50, // Adjust the width as needed
                  ),
                  const SizedBox(width: 10), // Add spacing between widgets
                  const Text(
                    "Create an Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle,
                      color: Color.fromRGBO(155, 93, 229, 1), size: 50),
                  SizedBox(width: 4),
                  Icon(Icons.circle_outlined,
                      color: Color.fromRGBO(155, 93, 229, 1), size: 50),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 239, 236, 239),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _companyNameController,
                  onChanged: (value) => organizerSignUp.updateOrgName(value),
                  decoration: InputDecoration(
                    labelText: 'What is the name of the company/group?',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 246, 244, 246),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove enabled border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove focused border
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please Enter Name'
                      : null,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 239, 236, 239),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _emailController,
                  onChanged: (value) => organizerSignUp.updateEmail(value),
                  decoration: InputDecoration(
                    labelText: 'What is the company email?',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 246, 244, 246),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove enabled border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove focused border
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 239, 236, 239),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _contactController,
                  onChanged: (value) =>
                      organizerSignUp.updatePhoneNumber(value),
                  decoration: InputDecoration(
                    labelText: 'What is the contact number?',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 246, 244, 246),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove enabled border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove focused border
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Input Contact Number';
                    }

                    final phoneExp = RegExp(r'^\d{10}$');
                    if (!phoneExp.hasMatch(value)) {
                      return 'Enter a valid 10-digit phone number';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 239, 236, 239),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _locationController,
                  onChanged: (value) =>
                      organizerSignUp.updateCompanyAddress(value),
                  decoration: InputDecoration(
                    labelText: 'Where is the company address?',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 246, 244, 246),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove enabled border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Remove focused border
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Input Company Address'
                      : null,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (formKey2.currentState!.validate()) {
                    goToNext(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Continue",
                    style: TextStyle(color: Colors.white, fontSize: 25)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
