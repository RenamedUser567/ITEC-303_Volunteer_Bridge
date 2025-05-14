import 'package:flutter/material.dart';
import 'package:volunteer_bridge/ScreensOrganizer/profile_organizer2.dart';
import 'package:volunteer_bridge/Services/auth.dart';

class ProfilePageOrg extends StatelessWidget {
  const ProfilePageOrg({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/mercedes-benz.jpg'),
                ),
                title: Text('The Jack of All Trades',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Total Volunteering Events Hosted: \n15 events'),
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
