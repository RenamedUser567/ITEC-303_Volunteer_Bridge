import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_edit_tag.dart';
import 'package:volunteer_bridge/ScreensVolunteer/volunteer_activities.dart';
import 'package:volunteer_bridge/models/event.dart';
import 'package:volunteer_bridge/riverpod/event_list.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';
import 'package:volunteer_bridge/riverpod/search_query.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

class HomePage2 extends ConsumerStatefulWidget {
  const HomePage2({super.key});

  @override
  ConsumerState<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends ConsumerState<HomePage2> {
  @override
  Widget build(BuildContext context) {
    final volData = ref.watch(volunteerProvider);
    if (volData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    ref.invalidate(filteredUnjoinedEventsProvider);
    final filteredEventsAsynch = ref.watch(filteredUnjoinedEventsProvider);
    final selectedTags = ref.watch(selectedTagsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SearchBarVol(ref: ref, selectedTags: selectedTags),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommendations',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  filteredEventsAsynch.when(
                    data: (events) {
                      if (events.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text('No events found'),
                          ),
                        );
                      }

                      return Column(
                        children: events.map((event) {
                          return EventCard(
                            event: event,
                            onVisitPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VolEventInfo(eventId: event.id),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stackTrace) => Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text('Error: $error'),
                      ),
                    ),
                  ),
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

class SearchBarVol extends StatelessWidget {
  const SearchBarVol({
    super.key,
    required this.ref,
    required this.selectedTags,
  });

  final WidgetRef ref;
  final List<String> selectedTags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) =>
            ref.read(searchQueryProvider.notifier).state = value,
        decoration: InputDecoration(
          hintText: 'Search Events...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.filter_list,
              color: selectedTags != [] ? Colors.black : Colors.black,
            ),
            onPressed: () {
              showTagFilterSearchDialog(context, ref);
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}

class EventCard extends ConsumerWidget {
  final Event event;
  final VoidCallback? onVisitPressed;

  const EventCard({
    super.key,
    required this.event,
    this.onVisitPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgName = ref.watch(organizerNameProvider(event.organizerId));

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
                child: event.bannerUrl.isNotEmpty
                    ? Image.asset(
                        event.bannerUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image,
                              size: 40, color: Colors.grey),
                        ),
                      )
                    : Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image,
                            size: 40, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 120,
                height: 30,
                child: ElevatedButton(
                  onPressed: onVisitPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 99, 2, 118),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                  child: const Text(
                    'More',
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
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.apartment, size: 14, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      orgName.value.toString(),
                      style: const TextStyle(
                          fontSize: 10,
                          color: Color.fromARGB(255, 97, 96, 96),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.alarm, size: 14, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatDate(event.start)} • ${event.timeStart} - ${event.timeEnd}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Color.fromARGB(255, 97, 96, 96),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.black),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Color.fromARGB(255, 97, 96, 96)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                if (event.tag.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 187, 132, 253),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.tag,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Simple date formatter
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

/*
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
*/

/*
try {
                                if (isJoined) {
                                  await EventService().leaveEvent(
                                      eventId: event.id, userId: volData.id);
                                } else {
                                  await EventService().joinEvent(
                                      eventId: event.id, userId: volData.id);
                                }
                                await ref
                                    .read(volunteerProvider.notifier)
                                    .loadVolunteer(volData.id);
                                ref.invalidate(filteredUnjoinedEventsProvider);
                              } catch (e) {
                                print(e);
                              }
*/
