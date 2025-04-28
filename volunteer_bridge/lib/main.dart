import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:volunteer_bridge/notifications.dart';
import 'package:volunteer_bridge/home.dart';
import 'package:volunteer_bridge/profile.dart';
import 'package:volunteer_bridge/activities.dart';
import 'package:volunteer_bridge/create_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
      resizeToAvoidBottomInset: false,
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

      floatingActionButton: Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateEventPage()),
            );
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 3, 
              color: Color.fromARGB(255, 155, 93, 229)
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 155, 93, 229),
          ),
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: myIndex,
          selectedItemColor: const Color.fromRGBO(155, 93, 229, 1),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
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
      ),
    );
  }
}