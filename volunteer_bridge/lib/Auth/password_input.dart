import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/Auth/wrapper.dart';
import 'package:volunteer_bridge/Services/auth.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

class PasswordInput extends ConsumerStatefulWidget {
  const PasswordInput({super.key});

  @override
  ConsumerState<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends ConsumerState<PasswordInput> {
  final TextEditingController _passwordController = TextEditingController();
  final passKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String? validatePassword(String? value) {
      const String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
      final regex = RegExp(pattern);

      if (value == null || value.isEmpty) {
        return 'Password is required';
      } else if (!regex.hasMatch(value)) {
        return 'Min 9 chars, 1 letter, 1 number';
      }
      return null;
    }

    final volunteerSignUp = ref.read(volunteerSignUpProvider);
    final organizerSignUp = ref.read(organizerSignUpProvider);

    Future<void> handleSignUp() async {
      final volunteer = ref.read(volunteerSignUpProvider);
      final organizer = ref.read(organizerSignUpProvider);

      final isVolunteer = volunteer.email.isNotEmpty;
      final email = isVolunteer ? volunteer.email : organizer.email;
      final password = _passwordController.text;

      try {
        final userCredential = await AuthService2().register(email, password);
        final uid = userCredential.user!.uid;

        final batch = FirebaseFirestore.instance.batch();

        final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
        batch.set(userDoc, {
          'id': uid,
          'email': email,
          'usertype': isVolunteer ? 'Volunteer' : 'Organizer',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (isVolunteer) {
          final newVolunteer = volunteerSignUp.copyWith(id: uid);
          final volunteerDoc =
              FirebaseFirestore.instance.collection('volunteers').doc(uid);
          batch.set(volunteerDoc, newVolunteer.toMap());
        } else {
          final newOrganizer = organizerSignUp.copyWith(id: uid);
          final organizerDoc =
              FirebaseFirestore.instance.collection('organizers').doc(uid);
          batch.set(organizerDoc, newOrganizer.toMap());
        }

        await batch.commit();

        if (isVolunteer) {
          ref.read(volunteerProvider.notifier).loadVolunteer(uid);
        } else {
          ref.read(organizerProvider.notifier).loadOrganizer(uid);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: $e')),
        );
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Wrapper2()),
        (route) => false, // removes all previous routes
      );
    }

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
        child: Form(
          key: passKey,
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
              TextFormField(
                validator: (value) => validatePassword(value),
                decoration: const InputDecoration(
                  labelText: 'PASSWORD',
                  filled: true,
                  fillColor: Color.fromARGB(255, 239, 236, 239),
                ),
                controller: _passwordController,
                obscureText: true,
                cursorErrorColor: Colors.redAccent,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Your password must have at least: \n 8 characters \n 1 letter \n 1 number',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (passKey.currentState!.validate()) {
                      handleSignUp();
                    }
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
      ),
    );
  }
}
