import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/models/user.dart';
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

  Future<void> updateOrganizer(Organizer updatedOrganizer) async {
    await FirebaseFirestore.instance
        .collection('organizers')
        .doc(updatedOrganizer.id)
        .update(updatedOrganizer.toMap());

    state = updatedOrganizer;
  }

  void clear() {
    state = null;
  }
}

final organizerProvider =
    NotifierProvider<OrganizerNotifier, Organizer?>(() => OrganizerNotifier());

const String defaultProfileUrl = 'assets/placeholder.jpg';

class OrganizerSignUpNotifier extends Notifier<Organizer> {
  @override
  Organizer build() {
    return Organizer(
      id: '',
      email: '',
      orgName: '',
      phoneNumber: '',
      companyAddress: '',
      companyDescription: '',
      profileUrl: defaultProfileUrl,
    );
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updateOrgName(String value) {
    state = state.copyWith(orgName: value);
  }

  void updatePhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void updateCompanyAddress(String value) {
    state = state.copyWith(companyAddress: value);
  }

  void updateCompanyDescription(String value) {
    state = state.copyWith(companyDescription: value);
  }

  void updateProfileUrl(String value) {
    state = state.copyWith(profileUrl: value);
  }

  void reset() {
    state = build();
  }
}

final organizerSignUpProvider =
    NotifierProvider<OrganizerSignUpNotifier, Organizer>(
  OrganizerSignUpNotifier.new,
);

//get name of organizer given id
final organizerNameProvider =
    FutureProvider.family<String, String>((ref, organizerId) async {
  final doc = await FirebaseFirestore.instance
      .collection('organizers')
      .doc(organizerId)
      .get();
  return doc.data()?['orgName'] ?? 'Unknown';
});
