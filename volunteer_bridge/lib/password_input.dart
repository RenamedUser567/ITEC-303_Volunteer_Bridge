import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/Auth/authenticate.dart';
import 'package:volunteer_bridge/Services/auth.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

class PasswordInput extends ConsumerWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*
    String? validatePassword(String? value) {
      const String pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z\d])[A-Za-z\d\W]{9,}$';
      final regex = RegExp(pattern);

      if (value == null || value.isEmpty) {
        return 'Password is required';
      } else if (!regex.hasMatch(value)) {
        return 'Min 9 chars, 1 letter, 1 number, 1 special char';
      }
      return null;
    }
    */

    final volunteerSignUp = ref.read(volunteerSignUpProvider);
    final TextEditingController password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your password',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'PASSWORD',
                filled: true,
                fillColor: Color.fromARGB(255, 239, 236, 239),
              ),
              controller: password,
              obscureText: true,
              cursorErrorColor: Colors.redAccent,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Your password must have at least: \n 8 characters \n 1 letter \n 1 number \n 1 special character',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final passcode = password.text;
                  final userCred = await AuthService2()
                      .register(volunteerSignUp.email, passcode);
                  print("Registered: ${userCred.user?.email}");

                  final uid = userCred.user!.uid;
                  final volunteer = ref.read(volunteerSignUpProvider);
                  final batch = FirebaseFirestore.instance.batch();

                  final userDoc =
                      FirebaseFirestore.instance.collection('users').doc(uid);
                  batch.set(userDoc, {
                    'id': uid,
                    'email': volunteerSignUp.email,
                    'usertype': volunteerSignUp.usertype,
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  final volunteerDoc = FirebaseFirestore.instance
                      .collection('volunteers')
                      .doc(uid);
                  batch.set(volunteerDoc, volunteer.copyWith(id: uid).toMap());

                  await batch.commit();

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const Wrapper3()),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 155, 93, 229),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                child: const Text(
                  'Register Account',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
