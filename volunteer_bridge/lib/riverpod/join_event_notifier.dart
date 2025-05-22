import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteer_bridge/Services/auth.dart';
import 'package:volunteer_bridge/models/user.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

final joinEventProvider =
    StateNotifierProvider.family<JoinNotifier, bool?, String>((ref, eventId) {
  return JoinNotifier(eventId: eventId, ref: ref);
});

class JoinEventNotifier extends StateNotifier<bool?> {
  final String eventId;
  final Ref ref;

  JoinEventNotifier({required this.eventId, required this.ref}) : super(null) {
    // Automatically update when volunteer changes
    ref.listen<Volunteer?>(volunteerProvider, (prev, next) {
      _checkIfJoined(next);
    });

    // Also check once at the start
    _checkIfJoined(ref.read(volunteerProvider));
  }

  void _checkIfJoined(Volunteer? volunteer) {
    if (volunteer == null) {
      state = null; // Still loading
      return;
    }

    final hasJoined = volunteer.joinedEvents.contains(eventId);
    if (state != hasJoined) state = hasJoined;
  }

  Future<void> joinEvent() async {
    final volunteer = ref.read(volunteerProvider);
    if (volunteer == null) return;

    final eventRef =
        FirebaseFirestore.instance.collection('events').doc(eventId);
    final volRef =
        FirebaseFirestore.instance.collection('users').doc(volunteer.id);

    await EventService().joinEvent(eventId: eventRef.id, userId: volRef.id);

    // Mark as joined
    state = true;
  }

  Future<void> leaveEvent() async {
    final volunteer = ref.read(volunteerProvider);
    if (volunteer == null) return;

    final eventRef =
        FirebaseFirestore.instance.collection('events').doc(eventId);
    final volRef =
        FirebaseFirestore.instance.collection('users').doc(volunteer.id);

    await EventService().leaveEvent(eventId: eventRef.id, userId: volRef.id);

    // Mark as not joined
    state = false;
  }
}

class JoinNotifier extends StateNotifier<bool?> {
  final String eventId;
  final Ref ref;

  JoinNotifier({required this.eventId, required this.ref}) : super(null) {
    ref.listen<Volunteer?>(volunteerProvider, (previous, next) {
      _checkIfJoined(next);
    });

    // Initial check
    _checkIfJoined(ref.read(volunteerProvider));
  }

  void _checkIfJoined(Volunteer? volunteer) {
    if (volunteer == null) return;

    final hasJoined = volunteer.joinedEvents.contains(eventId);
    if (state != hasJoined) state = hasJoined;
  }

  Future<void> joinEvent() async {
    final volunteer = ref.read(volunteerProvider);
    if (volunteer == null) return;

    final eventRef =
        FirebaseFirestore.instance.collection('events').doc(eventId);
    final volRef =
        FirebaseFirestore.instance.collection('users').doc(volunteer.id);

    await EventService().joinEvent(eventId: eventRef.id, userId: volRef.id);

    state = true;
  }

  Future<void> leaveEvent() async {
    final volunteer = ref.read(volunteerProvider);
    if (volunteer == null) return;

    final eventRef =
        FirebaseFirestore.instance.collection('events').doc(eventId);
    final volRef =
        FirebaseFirestore.instance.collection('users').doc(volunteer.id);

    await EventService().leaveEvent(eventId: eventRef.id, userId: volRef.id);

    state = false;
  }
}

final hasJoinedEventProvider = Provider.family<bool, String>((ref, eventId) {
  final volunteer = ref.watch(volunteerProvider);
  if (volunteer == null) return false;
  return volunteer.joinedEvents.contains(eventId);
});
