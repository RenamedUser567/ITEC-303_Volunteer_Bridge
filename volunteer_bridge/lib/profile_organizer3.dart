import 'package:flutter/material.dart';

class CompanyDescription extends StatefulWidget {
  const CompanyDescription({super.key});

  @override
  State<CompanyDescription> createState() => _CompanyDescriptionState();
}

class _CompanyDescriptionState extends State<CompanyDescription> {
  final TextEditingController _whoWeAreController = TextEditingController(
      text:
          "At Hearts United, we believe that compassion is a powerful force for change. Founded in 2018, our organization is built on the simple yet profound idea that communities thrive when people come together for a common purpose.");
  final TextEditingController _missionController = TextEditingController(
      text:
          "To unite hearts through community-driven volunteer events that uplift lives, promote kindness, and foster social responsibility.");
  final TextEditingController _joinUsController = TextEditingController(
      text:
          "Whether you're an individual looking to make a difference, or an organization wanting to collaborate, Hearts United welcomes you. Together, we can build a stronger, more compassionate community—one volunteer event at a time.");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/mercedes-benz.jpg'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(155, 93, 229, 1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("General Information"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Description"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 230, 249, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Who We Are",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _whoWeAreController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter details about who you are...",
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Our Mission",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _missionController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter your mission...",
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Join Us",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _joinUsController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter details about how to join...",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the update logic here
                print("Who We Are: ${_whoWeAreController.text}");
                print("Our Mission: ${_missionController.text}");
                print("Join Us: ${_joinUsController.text}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
