import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/Services/auth.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';

class OrgMain extends ConsumerStatefulWidget {
  const OrgMain({super.key});

  @override
  ConsumerState<OrgMain> createState() => _OrgMainState();
}

class _OrgMainState extends ConsumerState<OrgMain> {
  @override
  Widget build(BuildContext context) {
    final orgData = ref.watch(organizerProvider);

    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Text('Organization Information: \n'),
          Text('Org Name: ${orgData?.orgName}'),
          Text('Last Name: ${orgData?.email}'),
          Text('Description: ${orgData?.companyDescription}'),
          Text('Contact Num: ${orgData?.phoneNumber}'),
          ElevatedButton(
              onPressed: () => AuthService2().signOut(),
              child: const Text('Sign Out')),
        ],
      ),
    ));
  }
}
