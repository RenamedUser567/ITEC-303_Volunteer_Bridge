import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_edit_tag.dart';
import 'package:volunteer_bridge/models/event.dart';
import 'package:volunteer_bridge/riverpod/search_query.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

//get an org's managed events
final orgEventsStreamProvider =
    StreamProvider.family<List<Event>, String>((ref, organizerId) {
  return FirebaseFirestore.instance
      .collection('events')
      .where('organizerId', isEqualTo: organizerId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Event.fromMap(doc.id, doc.data()))
          .toList());
});

// with Joined Activity w/Search
final joinedEventsWithSearchProvider =
    StreamProvider.family<List<Event>, String>((ref, volunteerId) {
  final firestore = FirebaseFirestore.instance;
  final searchQuery = ref.watch(searchQueryActivitiesProvider).toLowerCase();

  return firestore
      .collection('volunteers')
      .doc(volunteerId)
      .snapshots()
      .asyncMap((doc) async {
    final data = doc.data();
    if (data == null || data['joinedEvents'] == null) return [];

    final List<String> joinedEventIds = List<String>.from(data['joinedEvents']);
    if (joinedEventIds.isEmpty) return [];

    final snapshots = await Future.wait(
      joinedEventIds.map((id) => firestore.collection('events').doc(id).get()),
    );

    final events = snapshots
        .where((eventDoc) => eventDoc.exists)
        .map((eventDoc) => Event.fromMap(eventDoc.id, eventDoc.data()!))
        .toList();

    if (searchQuery.isEmpty) return events;

    return events.where((event) {
      return event.title.toLowerCase().contains(searchQuery) ||
          event.description.toLowerCase().contains(searchQuery) ||
          event.tag.toLowerCase().contains(searchQuery);
    }).toList();
  });
});

//get all events
final eventsStreamProvider = StreamProvider<List<Event>>((ref) {
  return FirebaseFirestore.instance.collection('events').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Event.fromMap(doc.id, doc.data()))
          .toList());
});

final filteredOrgEventsProvider =
    Provider.family<AsyncValue<List<Event>>, String>((ref, organizerId) {
  final eventsAsync = ref.watch(orgEventsStreamProvider(organizerId));
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase().trim();
  final selectedTags = ref.watch(selectedTagsProvider);

  print(selectedTags);

  if (searchQuery.isEmpty && selectedTags.isEmpty) {
    return eventsAsync;
  }

  return eventsAsync.whenData((events) {
    return events.where((event) {
      final matchesSearch = searchQuery.isEmpty ||
          event.title.toLowerCase().contains(searchQuery) ||
          event.description.toLowerCase().contains(searchQuery) ||
          event.tag.toLowerCase().contains(searchQuery) ||
          event.location.toLowerCase().contains(searchQuery);

      final matchesTag =
          selectedTags.isEmpty || selectedTags.contains(event.tag);

      return matchesSearch && matchesTag;
    }).toList();
  });
});

//filter events based on search
final filteredEventsProvider = Provider<AsyncValue<List<Event>>>((ref) {
  final eventsAsyncValue = ref.watch(eventsStreamProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase().trim();

  // If search is empty, return all events (original stream result)
  if (searchQuery.isEmpty) {
    return eventsAsyncValue;
  }

  // Otherwise, filter the events based on search query
  return eventsAsyncValue.whenData((events) {
    return events.where((event) {
      return event.title.toLowerCase().contains(searchQuery) ||
          event.description.toLowerCase().contains(searchQuery) ||
          (event.tag.toLowerCase()).contains(searchQuery) ||
          event.location.toLowerCase().contains(searchQuery);
    }).toList();
  });
});

// for home page display events where volunteer havent joined
final filteredUnjoinedEventsProvider = Provider<AsyncValue<List<Event>>>((ref) {
  final eventsAsync = ref.watch(eventsStreamProvider);
  final volunteer = ref.watch(volunteerProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase().trim();
  final selectedTags = ref.watch(selectedTagsProvider);

  if (volunteer == null) return const AsyncValue.data([]);

  return eventsAsync.whenData((events) {
    final unjoinedEvents = events.where(
      (event) => !volunteer.joinedEvents.contains(event.id),
    );

    final matchesTag = unjoinedEvents.where(
        (event) => selectedTags.isEmpty || selectedTags.contains(event.tag));

    if (searchQuery.isEmpty) {
      return matchesTag.toList();
    }

    final matchesSearch = matchesTag.where((event) {
      return event.title.toLowerCase().contains(searchQuery) ||
          event.description.toLowerCase().contains(searchQuery) ||
          event.tag.toLowerCase().contains(searchQuery) ||
          event.location.toLowerCase().contains(searchQuery);
    });

    return matchesSearch.toList();
  });
});

//fetch event information
class EventNotifier extends Notifier<Event?> {
  @override
  Event? build() {
    return null; // initial state is null
  }

  /// Loads the event from Firestore by ID
  Future<void> loadEvent(String eventId) async {
    final doc = await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .get();

    if (doc.exists) {
      state = Event.fromMap(doc.id, doc.data()!);
    }
  }

  /// Updates the event in Firestore and local state
  Future<void> updateEvent(Event updatedEvent) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(updatedEvent.id)
        .update(updatedEvent.toMap());

    state = updatedEvent;
  }

  /// Clears the local state
  void clear() {
    state = null;
  }
}

//event provider
final eventNotifierProvider = NotifierProvider<EventNotifier, Event?>(() {
  return EventNotifier();
});
