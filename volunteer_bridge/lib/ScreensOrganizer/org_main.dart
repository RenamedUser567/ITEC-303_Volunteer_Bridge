import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_activities.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_create_event.dart';
import 'package:volunteer_bridge/ScreensOrganizer/profile_organizer.dart';

class OrganizerMainPage extends StatefulWidget {
  const OrganizerMainPage({super.key});

  @override
  State<OrganizerMainPage> createState() => _OrganizerMainPageState();
}

class _OrganizerMainPageState extends State<OrganizerMainPage> {
  int myIndex = 0;
  List<Widget> pageList = [
    const ActivitiesPage(),
    const ProfilePageOrg(),
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
                width: 3, color: Color.fromARGB(255, 155, 93, 229)),
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
        padding: const EdgeInsets.all(0.0),
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
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
                icon: Icon(Icons.calendar_today), label: 'Activities'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
