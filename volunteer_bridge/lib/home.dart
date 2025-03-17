import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchBar(),
          ),

          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommendations',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  EventCard(
                    imageUrl: 'assets/ImageFrame.png',
                    title: 'Donation Drive',
                    location: 'Quezon City, Manila',
                    time: '10 AM, April 5',
                    description: 'Come together with us to spread kindness and compassion through Hearts United...',
                    tags: ['Donations', 'Non-Profit', 'Community Service'],
                  ),
                  
                  EventCard(
                    imageUrl: 'assets/ImageFrame.png',
                    title: 'Tree Planting',
                    location: 'Laguna, Philippines',
                    time: '8 AM, April 12',
                    description: 'Join us in restoring nature by planting trees in local parks...',
                    tags: ['Environment', 'Sustainability', 'Volunteer'],
                  ),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

         
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                CategoryButton(label: 'Tree Planting'),
                CategoryButton(label: 'Blood Drive'),
                CategoryButton(label: 'Cleanup'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Events...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.filter_list),
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

  const EventCard({
    super.key,
    required this.title,
    required this.location,
    required this.time,
    required this.description,
    required this.tags,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
               
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Join', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
               
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(fontSize: 8, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    Text(time, style: const TextStyle(fontSize: 8, color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 8),

                
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),

                const SizedBox(height: 8),

               
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: tags
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ))
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

class CategoryButton extends StatelessWidget {
  final String label;

  const CategoryButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}
