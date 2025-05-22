import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/ScreensOrganizer/profile_organizer2.dart';
import 'package:volunteer_bridge/Services/auth.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';

class ProfilePageOrg extends ConsumerStatefulWidget {
  const ProfilePageOrg({super.key});

  @override
  ConsumerState<ProfilePageOrg> createState() => _ProfilePageOrgState();
}

class _ProfilePageOrgState extends ConsumerState<ProfilePageOrg> {
  @override
  Widget build(BuildContext context) {
    final orgData = ref.watch(organizerProvider);

    if (orgData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final eventCount = EventService().countOrganizerEvents(orgData.id);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              color: const Color.fromRGBO(238, 230, 249, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: buildProfileImage(orgData.profileUrl),
                ),
                title: Text(orgData.orgName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: FutureBuilder<int>(
                    future: eventCount,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading event count...');
                      } else if (snapshot.hasError) {
                        return const Text('Error loading events');
                      } else {
                        return Text(
                            'Total Volunteering Events Hosted: ${snapshot.data}');
                      }
                    }),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color.fromRGBO(238, 230, 249, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      'My Account',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Make changes to your account'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompanyGeneralInfo(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text(
                      'Log out',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        const Text('Further secure your account for safety'),
                    onTap: () => AuthService2().signOut(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text(
                      'Help and support',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text(
                      'About app',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

ImageProvider buildProfileImage(String profileUrl) {
  if (profileUrl.startsWith('http')) {
    return NetworkImage(profileUrl);
  } else if (profileUrl.startsWith('/')) {
    return FileImage(File(profileUrl));
  } else {
    return AssetImage(profileUrl);
  }
}
