import 'dart:ui';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> allEvents = [
    Event(
      imageUrl: 'assets/ImageFrame.png',
      title: 'Donation Drive',
      subtitle: 'Hearts United',
      location: 'Quezon City, Manila',
      time: '10 AM, April 5',
      description:
          'Come together with us to spread kindness and compassion through Hearts United...',
      tags: ['Social Services'],
    ),
    Event(
      imageUrl: 'assets/ImageFrame.png',
      title: 'Tree Planting',
      subtitle: 'Green Earth Initiative',
      location: 'Laguna, Philippines',
      time: '8 AM, April 12',
      description:
          'Join us in restoring nature by planting trees in local parks...',
      tags: ['Environment'],
    ),
    Event(
      imageUrl: 'assets/ImageFrame.png',
      title: 'Animal Shelter Volunteering',
      subtitle: 'Paws and Claws',
      location: 'Makati City, Manila',
      time: '9 AM, May 1',
      description: 'Help take care of rescued animals in our local shelter...',
      tags: ['Animals'],
    ),
  ];

  List<Event> filteredEvents = [];
  List<String> allTags = [
    'Animals',
    'Social Services',
    'Environment',
    'Medical Care',
    'Recreation and Sports'
  ];
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    filteredEvents = allEvents;
  }

  void _filterEvents(String query) {
    final results = allEvents.where((event) {
      final titleLower = event.title.toLowerCase();
      final tagsLower = event.tags.join(' ').toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          tagsLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredEvents = results;
    });
  }

  void _filterByTags() {
    if (selectedTags.isEmpty) {
      setState(() {
        filteredEvents = allEvents;
      });
    } else {
      final results = allEvents.where((event) {
        return event.tags.any((tag) => selectedTags.contains(tag));
      }).toList();
      setState(() {
        filteredEvents = results;
      });
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Filter by Tags'),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allTags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return ChoiceChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedTags.add(tag);
                    } else {
                      selectedTags.remove(tag);
                    }
                  });
                },
                selectedColor: const Color.fromARGB(255, 187, 132, 253),
                backgroundColor: Colors.grey[300],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _filterByTags();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              onChanged: _filterEvents,
              onFilterPressed: _showFilterDialog,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommendations',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...filteredEvents.map((event) => EventCard(
                        imageUrl: event.imageUrl,
                        title: event.title,
                        subtitle: event.subtitle,
                        location: event.location,
                        time: event.time,
                        description: event.description,
                        tags: event.tags,
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;

  const SearchBar(
      {super.key, required this.onChanged, required this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search Events...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: onFilterPressed,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String time;
  final String description;
  final List<String> tags;
  final String imageUrl;
  final String subtitle;

  const EventCard({
    super.key,
    required this.title,
    required this.location,
    required this.time,
    required this.description,
    required this.tags,
    required this.imageUrl,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 230, 249),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Join Button Column
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child:
                        const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 120,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                  child: const Text(
                    'Join Event',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Event Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 187, 132, 253),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  final String location;
  final String time;
  final String description;
  final List<String> tags;
  final String imageUrl;
  final String subtitle;

  Event({
    required this.title,
    required this.location,
    required this.time,
    required this.description,
    required this.tags,
    required this.imageUrl,
    required this.subtitle,
  });
}
