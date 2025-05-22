import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerNotifier extends Notifier<Volunteer?> {
  @override
  Volunteer? build() {
    return null;
  }

  Future<void> loadVolunteer(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('volunteers')
        .doc(uid)
        .get();
    if (doc.exists) {
      state = Volunteer.fromMap(doc.id, doc.data()!);
    }
  }

  Future<void> updateVolunteer(Volunteer updatedVolunteer) async {
    await FirebaseFirestore.instance
        .collection('volunteers')
        .doc(updatedVolunteer.id)
        .update(updatedVolunteer.toMap());

    state = updatedVolunteer;
  }

  void clear() {
    state = null;
  }
}

final volunteerProvider =
    NotifierProvider<VolunteerNotifier, Volunteer?>(() => VolunteerNotifier());
const String defaultProfileUrl = 'assets/placeholder.jpg';

class VolunteerSignUpNotifier extends Notifier<Volunteer> {
  @override
  Volunteer build() {
    return Volunteer(
      id: '',
      firstName: '',
      lastName: '',
      contactNumber: '',
      birthDate: DateTime.now(),
      gender: '',
      latitude: 0,
      longitude: 0,
      email: '',
      address: '',
      completedEvents: 0,
      profileUrl: defaultProfileUrl,
      joinedEvents: [],
    );
  }

  void updateFirstName(String value) {
    state = state.copyWith(firstName: value);
  }

  void updateLastName(String value) {
    state = state.copyWith(lastName: value);
  }

  void updateContactNum(String value) {
    state = state.copyWith(contactNumber: value);
  }

  void updateBirthDate(DateTime value) {
    state = state.copyWith(birthDate: value);
  }

  void updateLatitudeLongitude(double lat, double long) {
    state = state.copyWith(latitude: lat);
    state = state.copyWith(longitude: long);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void incrementCompletedEvents() {
    state = state.copyWith(completedEvents: state.completedEvents + 1);
  }

  void updateGender(String value) {
    state = state.copyWith(gender: value);
  }

  void updateAddress(String value) {
    state = state.copyWith(address: value);
  }

  void updateProfileUrl(String value) {
    state = state.copyWith(profileUrl: value);
  }

  void reset() {
    state = build();
  }
}

final volunteerSignUpProvider =
    NotifierProvider<VolunteerSignUpNotifier, Volunteer>(
  VolunteerSignUpNotifier.new,
);

//get list of Volunteers from joinedVolunteers list for activities_org
final volunteersProvider =
    FutureProvider.family<List<Volunteer>, String>((ref, eventId) async {
  final eventSnapshot =
      await FirebaseFirestore.instance.collection('events').doc(eventId).get();

  if (!eventSnapshot.exists) {
    return [];
  }

  final eventData = eventSnapshot.data() as Map<String, dynamic>;

  if (!eventData.containsKey('joinedVolunteers') ||
      (eventData['joinedVolunteers'] as List).isEmpty) {
    return [];
  }

  final List<dynamic> volunteerIds = eventData['joinedVolunteers'];

  List<Volunteer> volunteers = [];
  for (var volunteerId in volunteerIds) {
    try {
      String userId =
          volunteerId is String ? volunteerId : volunteerId.toString();

      DocumentSnapshot volunteerDoc = await FirebaseFirestore.instance
          .collection('volunteers')
          .doc(userId)
          .get();

      if (volunteerDoc.exists) {
        final data = volunteerDoc.data() as Map<String, dynamic>;

        volunteers.add(Volunteer.fromMap(volunteerDoc.id, data));
      }
    } catch (e) {
      print('Error fetching volunteer: $e');
    }
  }

  return volunteers;
});
