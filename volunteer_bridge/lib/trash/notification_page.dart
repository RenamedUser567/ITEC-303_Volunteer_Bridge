import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VolunteerBridgeApp extends StatelessWidget {
  const VolunteerBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volunteer Bridge',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Default to Notifications Page

  final List<Widget> _pages = [
    const Center(
        child: Text('This is the Home page', style: TextStyle(fontSize: 22))),
    const NotificationsPage(),
    const Center(
        child: Text('This is the Activities page',
            style: TextStyle(fontSize: 22))),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected page
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 155, 93, 229),
        title: const Text(
          'Volunteer Bridge',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Tracks active page
        selectedItemColor: const Color.fromRGBO(155, 93, 229, 1),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildNotificationSection('Unread', [
              _buildNotificationItem('Lorem 1s',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...',
                  isRead: false),
              _buildNotificationItem('Lorem 1s',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...',
                  isRead: false),
              _buildNotificationItem('Lorem 1d',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...',
                  isRead: false),
            ]),
            _buildNotificationSection('All', [
              _buildNotificationItem('Lorem 1w',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...',
                  isRead: true),
              _buildNotificationItem('Lorem more than 30 days',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...',
                  isRead: true),
              _buildNotificationItem('Lorem more than 30 days',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...',
                  isRead: true),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...items,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNotificationItem(String message, String time,
      {required bool isRead}) {
    return Container(
      decoration: BoxDecoration(
        color: isRead
            ? const Color.fromARGB(255, 239, 236, 239)
            : const Color.fromARGB(
                255, 238, 230, 239), // Conditional background color
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const SvgPlaceholder(), // Placeholder for SVG icon
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(time),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder widget for the SVG icon
class SvgPlaceholder extends StatelessWidget {
  const SvgPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/Handshake.svg', height: 40, width: 40);
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is the Profile page',
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}
