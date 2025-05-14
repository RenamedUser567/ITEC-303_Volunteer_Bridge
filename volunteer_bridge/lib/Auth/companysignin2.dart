import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:volunteer_bridge/Auth/password_input.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';

class CompanyInfoStep2 extends ConsumerWidget {
  final _descriptionController = TextEditingController();

  CompanyInfoStep2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizerSignUp = ref.read(organizerSignUpProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
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
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle,
                    color: Color.fromRGBO(155, 93, 229, 1), size: 50),
                SizedBox(width: 4),
                Icon(Icons.circle,
                    color: Color.fromRGBO(155, 93, 229, 1), size: 50),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                onChanged: (value) =>
                    organizerSignUp.updateCompanyDescription(value),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText:
                      "Add a description about your company/organization...\nMaximum of 200 words...",
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: const Color.fromARGB(255, 246, 244, 246),
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PasswordInput()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
