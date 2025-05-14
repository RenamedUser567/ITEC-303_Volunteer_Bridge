import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/Services/auth.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

class VolMain extends ConsumerStatefulWidget {
  const VolMain({super.key});

  @override
  ConsumerState<VolMain> createState() => _VolMainConsumerState();
}

class _VolMainConsumerState extends ConsumerState<VolMain> {
  @override
  Widget build(BuildContext context) {
    final volData = ref.watch(volunteerProvider);

    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Text('Volunteer Information: \n'),
          Text('First Name: ${volData?.firstName}'),
          Text('Last Name: ${volData?.lastName}'),
          Text('Bday: ${volData?.birthDate}'),
          Text('Contact Num: ${volData?.contactNumber}'),
          Text('Email: ${volData?.email}'),
          Text('Location: ${volData?.latitude} & ${volData?.longitude}'),
          Text('Events: ${volData?.completedEvents}'),
          ElevatedButton(
              onPressed: () => AuthService2().signOut(),
              child: const Text('Sign Out')),
        ],
      ),
    ));
  }
}
