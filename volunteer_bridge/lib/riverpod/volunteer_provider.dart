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

  void clear() {
    state = null;
  }
}

final volunteerProvider =
    NotifierProvider<VolunteerNotifier, Volunteer?>(() => VolunteerNotifier());

class VolunteerSignUpNotifier extends Notifier<Volunteer> {
  @override
  Volunteer build() {
    return Volunteer(
      id: '',
      firstName: '',
      lastName: '',
      contactNumber: '',
      birthDate: DateTime.now(),
      latitude: 0,
      longitude: 0,
      email: '',
      completedEvents: 0,
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

  void reset() {
    state = build();
  }
}

final volunteerSignUpProvider =
    NotifierProvider<VolunteerSignUpNotifier, Volunteer>(
  VolunteerSignUpNotifier.new,
);
