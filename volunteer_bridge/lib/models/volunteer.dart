import 'package:cloud_firestore/cloud_firestore.dart';

class Volunteer {
  final String id;
  final String firstName;
  final String lastName;
  final String contactNumber;
  final DateTime birthDate;
  final double latitude;
  final double longitude;
  final String email;
  final int completedEvents;

  Volunteer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.birthDate,
    required this.latitude,
    required this.longitude,
    required this.email,
    this.completedEvents = 0,
  });

  factory Volunteer.fromMap(String id, Map<String, dynamic> data) {
    return Volunteer(
      id: id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      contactNumber: data['contactNumber'],
      birthDate: data['birthDate'] is Timestamp
          ? (data['birthDate'] as Timestamp).toDate()
          : data['birthDate'] as DateTime,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      email: data['email'],
      completedEvents: data['completedEvents'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'contactNumber': contactNumber,
      'birthDate': Timestamp.fromDate(birthDate),
      'latitude': latitude,
      'longitude': longitude,
      'email': email,
      'completedEvents': completedEvents,
    };
  }

  Volunteer copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? contactNumber,
    DateTime? birthDate,
    double? latitude,
    double? longitude,
    String? email,
    int? completedEvents,
  }) {
    return Volunteer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      contactNumber: contactNumber ?? this.contactNumber,
      birthDate: birthDate ?? this.birthDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      email: email ?? this.email,
    );
  }
}
