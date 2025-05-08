import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/models/organizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizerNotifier extends Notifier<Organizer?> {
  @override
  Organizer? build() {
    return null;
  }

  Future<void> loadOrganizer(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('organizers')
        .doc(uid)
        .get();
    if (doc.exists) {
      state = Organizer.fromMap(doc.id, doc.data()!);
    }
  }

  void clear() {
    state = null;
  }
}

final organizerProvider =
    NotifierProvider<OrganizerNotifier, Organizer?>(() => OrganizerNotifier());
