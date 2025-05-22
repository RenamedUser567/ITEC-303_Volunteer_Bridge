import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:volunteer_bridge/notifications.dart';
import 'package:volunteer_bridge/ScreensVolunteer/home.dart';
import 'package:volunteer_bridge/ScreensVolunteer/profile.dart';
import 'package:volunteer_bridge/ScreensVolunteer/activities.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int myIndex = 0;
  List<Widget> pageList = [
    const HomePage(),
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
            SvgPicture.asset('assets/Handshake.svg', height: 40, width: 40),
            const SizedBox(width: 10),
            const Text(
              'Volunteer Bridge',
              style: TextStyle(color: Colors.black),
            ),
            const Spacer(), // Pushes the icon to the right
            IconButton(
              icon: const Icon(Icons.notifications_none,
                  color: Colors.black, weight: 40, size: 40),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: pageList[myIndex],
      ),

      // resizeToAvoidBottomInset: false,
      // // Add this FAB
      // floatingActionButton: Container(
      //   height: 64,
      //   width: 64,
      //   margin: const EdgeInsets.only(top: 10),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.white,
      //     elevation: 0,
      //     onPressed: () => debugPrint("Add Button pressed"),
      //     shape: RoundedRectangleBorder(
      //       side: const BorderSide(
      //           width: 3, color: Color.fromARGB(255, 155, 93, 229)),
      //       borderRadius: BorderRadius.circular(100),
      //     ),
      //     child: const Icon(
      //       Icons.add,
      //       color: Color.fromARGB(255, 155, 93, 229),
      //     ),
      //   ),
      // ),

      // // Center the FAB in the nav bar
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Modify your BottomNavigationBar slightly to accommodate the FAB
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              // Home
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      myIndex = 0;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home,
                          color: myIndex == 0
                              ? const Color(0xFF9B5DE5)
                              : Colors.grey),
                      Text("Home",
                          style: TextStyle(
                              color: myIndex == 0
                                  ? const Color(0xFF9B5DE5)
                                  : Colors.grey,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ),

              // // Spacer for FAB
              // const SizedBox(width: 40),

              // Activities
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      myIndex = 1;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          color: myIndex == 1
                              ? const Color(0xFF9B5DE5)
                              : Colors.grey),
                      Text("Activities",
                          style: TextStyle(
                              color: myIndex == 1
                                  ? const Color(0xFF9B5DE5)
                                  : Colors.grey,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ),

              // Profile
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      myIndex = 2;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person,
                          color: myIndex == 2
                              ? const Color(0xFF9B5DE5)
                              : Colors.grey),
                      Text(
                        "Profile",
                        style: TextStyle(
                            color: myIndex == 2
                                ? const Color(0xFF9B5DE5)
                                : Colors.grey,
                            fontSize: 12),
                      ),
                    ],
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
