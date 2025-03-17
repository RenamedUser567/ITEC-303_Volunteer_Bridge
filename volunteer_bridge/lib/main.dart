import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:volunteer_bridge/notifications.dart';
import 'package:volunteer_bridge/home.dart';
import 'package:volunteer_bridge/profile.dart';
import 'package:volunteer_bridge/activities.dart';

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
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int myIndex = 0;
  List<Widget> pageList = [
    const HomePage(),
    NotificationsPage(),
    const ActivitiesPage(),
    const ProfilePage(),
  ];
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

      body: Center(
        child: pageList[myIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },

        currentIndex: myIndex,
        selectedItemColor: const Color.fromRGBO(155, 93, 229, 1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications), 
            label: 'Notifications'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), 
            label: 'Activities'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Profile'
          ),
        ],
      ),
    );
  }
}

