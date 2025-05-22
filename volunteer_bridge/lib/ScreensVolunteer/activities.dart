import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_activities.dart';
import 'package:volunteer_bridge/ScreensVolunteer/volunteer_activities.dart';
import 'package:volunteer_bridge/riverpod/event_list.dart';
import 'package:volunteer_bridge/riverpod/search_query.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

class ActivitiesPage extends ConsumerWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volData = ref.watch(volunteerProvider);

    if (volData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final eventsAsync = ref.watch(joinedEventsWithSearchProvider(volData.id));
    final searchQuery = ref.watch(searchQueryActivitiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search and filter section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchBarActivities(),
          ),

          // Activities title and tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(155, 93, 229, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Joined Activities',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      tagDisplay(),
                      const SizedBox(width: 8),
                      tagDisplay(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: eventsAsync.when(
              data: (events) {
                if (events.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        searchQuery.isEmpty
                            ? 'No Events Available'
                            : 'No Results Found for "$searchQuery"',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      if (searchQuery.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            ref.read(searchQueryProvider.notifier).state = '';
                          },
                          child: const Text('Clear Search'),
                        ),
                      const Center(
                        child: Text(
                          'No Events Found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ActivityCardVol(
                        title: event.title,
                        timeAgo: countdownUntilDaysOnly(event.start),
                        subtitle: event.description,
                        tag: event.tag,
                        id: event.id,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Container tagDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Category',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }
}

class ActivityCardVol extends StatelessWidget {
  final String title;
  final String timeAgo;
  final String subtitle;
  final String tag;
  final String id;

  const ActivityCardVol({
    super.key,
    required this.title,
    required this.timeAgo,
    required this.subtitle,
    required this.tag,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VolEventInfo(eventId: id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(215, 255, 255, 255),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey
                  .withValues(red: 128, green: 128, blue: 128, alpha: 25),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: getColorForTag(tag),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIconForTag(tag),
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 40),
                          child: Text(
                            timeAgo,
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 80,
              height: 60,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/ImageFrame.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarActivities extends ConsumerWidget {
  const SearchBarActivities({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Activities...', // Changed text
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons
            .filter_list), //IconButton(icon: const Icon(Icons.filter_list), onPressed: showTagFilterSearchDialog),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onChanged: (value) {
        ref.read(searchQueryActivitiesProvider.notifier).state = value;
      },
    );
  }
}
