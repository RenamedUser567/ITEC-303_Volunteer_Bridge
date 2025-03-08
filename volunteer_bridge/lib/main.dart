import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Volunteer Bridge',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(155, 93, 229, 1),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            SvgPicture.asset('assets/Handshake.svg', height: 30, width: 30),
            const SizedBox(width: 10),
            const Text('Volunteer Bridge',
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
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
                  backgroundImage: AssetImage('assets/ksi.jpg'),
                ),
                title: Text('Olajide Olayinka Williams Olatunji'),
                subtitle: Text('Total Hours Volunteering: 69 hours'),
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
                    title: const Text('My Account'),
                    subtitle: const Text('Make changes to your account'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log out'),
                    subtitle:
                        const Text('Further secure your account for safety'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('More',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              color: const Color.fromRGBO(238, 230, 249, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help and support'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About app'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(155, 93, 229, 1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Activities'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
