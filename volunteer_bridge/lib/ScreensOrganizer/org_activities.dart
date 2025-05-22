// activities.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_edit_tag.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_event_info.dart';
import 'package:volunteer_bridge/riverpod/event_list.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';
import 'package:volunteer_bridge/riverpod/search_query.dart';

class SearchBar extends ConsumerWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Activities...', // Changed text
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            showTagFilterSearchDialog(context, ref);
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).state = value;
      },
    );
  }
}

class ActivitiesPage extends ConsumerWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgData = ref.watch(organizerProvider);

    if (orgData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final eventsAsync = ref.watch(filteredOrgEventsProvider(orgData.id));
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search and filter section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchBar(),
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
                          'Managed Activities',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                      ),
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
                      child: ActivityCard(
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
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String timeAgo;
  final String subtitle;
  final String tag;
  final String id;

  const ActivityCard({
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
            builder: (context) => OrgEventInfo(eventId: id),
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
                    const SizedBox(height: 5),
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
              width: 64,
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

String countdownUntilDaysOnly(DateTime startTime) {
  final now = DateTime.now();
  final startDate = DateTime(startTime.year, startTime.month, startTime.day);
  final currentDate = DateTime(now.year, now.month, now.day);
  final difference = startDate.difference(currentDate).inDays;

  if (difference < 0) {
    return 'Started';
  } else if (difference == 0) {
    return 'Today';
  } else if (difference == 1) {
    return '1d';
  } else {
    return '${difference}d';
  }
}

IconData getIconForTag(String? tag) {
  if (tag == null || tag.isEmpty) return Icons.event;

  switch (tag.toLowerCase()) {
    case 'environment':
      return Icons.nature;
    case 'animals':
      return Icons.pets;
    case 'recreation and sports':
      return Icons.sports;
    case 'medical care':
      return Icons.medical_services;
    case 'social service':
      return Icons.group;
    default:
      return Icons.event;
  }
}

Color getColorForTag(String? tag) {
  if (tag == null || tag.isEmpty) return Colors.blue;
  switch (tag.toLowerCase()) {
    case 'environment':
      return Colors.green;
    case 'animals':
      return Colors.brown;
    case 'recreation and sports':
      return Colors.orange;
    case 'social service':
      return Colors.purple;
    case 'medical care':
      return Colors.red;
    default:
      return Colors.blue;
  }
}
