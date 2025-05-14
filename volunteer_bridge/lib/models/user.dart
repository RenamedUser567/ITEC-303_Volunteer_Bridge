import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppUser {
  final String id;
  final String usertype;
  final String email;

  AppUser({
    required this.id,
    required this.usertype,
    required this.email,
  });

  Map<String, dynamic> toBaseMap() => {
        'id': id,
        'usertype': usertype,
        'email': email,
      };

  AppUser copyWith({
    String? id,
    String? email,
  });
}

class Organizer extends AppUser {
  final String orgName;
  final String phoneNumber;
  final String companyAddress;
  final String companyDescription;

  Organizer({
    required super.id,
    required super.email,
    required this.orgName,
    required this.phoneNumber,
    required this.companyAddress,
    required this.companyDescription,
  }) : super(usertype: "Organizer");

  factory Organizer.fromMap(String id, Map<String, dynamic> data) {
    return Organizer(
      id: id,
      email: data['email'],
      orgName: data['orgName'],
      phoneNumber: data['phoneNumber'],
      companyAddress: data['companyAddress'],
      companyDescription: data['companyDescription'],
    );
  }

  Map<String, dynamic> toMap() => {
        ...toBaseMap(),
        'orgName': orgName,
        'phoneNumber': phoneNumber,
        'companyAddress': companyAddress,
        'companyDescription': companyDescription,
      };

  @override
  Organizer copyWith({
    String? id,
    String? email,
    String? orgName,
    String? phoneNumber,
    String? companyAddress,
    String? companyDescription,
  }) {
    return Organizer(
      id: id ?? this.id,
      email: email ?? this.email,
      orgName: orgName ?? this.orgName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      companyAddress: companyAddress ?? this.companyAddress,
      companyDescription: companyDescription ?? this.companyDescription,
    );
  }
}

class Volunteer extends AppUser {
  final String firstName;
  final String lastName;
  final String contactNumber;
  final DateTime birthDate;
  final double latitude;
  final double longitude;
  final int completedEvents;

  Volunteer({
    required super.id,
    required super.email,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.birthDate,
    required this.latitude,
    required this.longitude,
    required this.completedEvents,
  }) : super(usertype: "Volunteer");

  factory Volunteer.fromMap(String id, Map<String, dynamic> data) {
    return Volunteer(
      id: id,
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      contactNumber: data['contactNumber'],
      birthDate: (data['birthDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      completedEvents: data['completedEvents'],
    );
  }

  Map<String, dynamic> toMap() => {
        ...toBaseMap(),
        'firstName': firstName,
        'lastName': lastName,
        'contactNumber': contactNumber,
        'birthDate': birthDate,
        'latitude': latitude,
        'longitude': longitude,
        'completedEvents': completedEvents,
      };

  @override
  Volunteer copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? contactNumber,
    DateTime? birthDate,
    double? latitude,
    double? longitude,
    int? completedEvents,
  }) {
    return Volunteer(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      contactNumber: contactNumber ?? this.contactNumber,
      birthDate: birthDate ?? this.birthDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      completedEvents: completedEvents ?? this.completedEvents,
    );
  }
}
