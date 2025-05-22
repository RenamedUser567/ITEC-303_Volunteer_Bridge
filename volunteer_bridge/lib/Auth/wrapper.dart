import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_edit_tag.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_main.dart';
import 'package:volunteer_bridge/Auth/log_in.dart';
import 'package:volunteer_bridge/ScreensVolunteer/vol_main.dart';
import 'package:volunteer_bridge/riverpod/auth_provider.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

class Wrapper2 extends ConsumerWidget {
  const Wrapper2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return authAsync.when(
      data: (user) {
        if (user == null) return const Login();

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final userType = data['usertype'];
            ref.invalidate(tagOptionsProvider);

            if (userType == 'Volunteer') {
              ref.read(volunteerProvider.notifier).loadVolunteer(user.uid);
              return const VolunteerMainPage();
            } else if (userType == 'Organizer') {
              ref.read(organizerProvider.notifier).loadOrganizer(user.uid);
              return const OrganizerMainPage();
            } else {
              return const Login();
            }
          },
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
    );
  }
}

/*
class Wrapper3 extends ConsumerWidget {
  const Wrapper3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseUserAsync = ref.watch(authStateProvider);
    //final userDocAsync = ref.watch(userProvider);

    return firebaseUserAsync.when(
      data: (firebaseUser) {
        //print("User: $firebaseUser");
        if (firebaseUser == null) {
          return const Login();
        }
        //print("Navigating to MainPage...");
        return const MainPage();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}*/
