import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppUser {
  final String id;
  final String usertype;
  final String email;
  final String profileUrl;

  AppUser({
    required this.id,
    required this.usertype,
    required this.email,
    required this.profileUrl,
  });

  Map<String, dynamic> toBaseMap() => {
        'id': id,
        'usertype': usertype,
        'email': email,
        'profileUrl': profileUrl,
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
    required super.profileUrl,
    required this.orgName,
    required this.phoneNumber,
    required this.companyAddress,
    required this.companyDescription,
  }) : super(usertype: "Organizer");

  factory Organizer.fromMap(String id, Map<String, dynamic> data) {
    return Organizer(
      id: id,
      email: data['email'],
      profileUrl: data['profileUrl'],
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
    String? profileUrl,
  }) {
    return Organizer(
      id: id ?? this.id,
      email: email ?? this.email,
      orgName: orgName ?? this.orgName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      companyAddress: companyAddress ?? this.companyAddress,
      companyDescription: companyDescription ?? this.companyDescription,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}

class Volunteer extends AppUser {
  final String firstName;
  final String lastName;
  final String contactNumber;
  final DateTime birthDate;
  final String gender;
  final String address;
  final double latitude;
  final double longitude;
  final int completedEvents;
  final List<String> joinedEvents;

  Volunteer({
    required super.id,
    required super.email,
    required super.profileUrl,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.gender,
    required this.address,
    required this.birthDate,
    required this.latitude,
    required this.longitude,
    required this.completedEvents,
    this.joinedEvents = const [],
  }) : super(usertype: "Volunteer");

  factory Volunteer.fromMap(String id, Map<String, dynamic> data) {
    List<String> eventIds = [];
    if (data['joinedEvents'] != null) {
      eventIds = List<String>.from(data['joinedEvents']);
    }

    return Volunteer(
      id: id,
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      contactNumber: data['contactNumber'],
      gender: data['gender'] ?? '',
      birthDate: (data['birthDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      address: data['address'] ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      completedEvents: data['completedEvents'],
      profileUrl: data['profileUrl'],
      joinedEvents: eventIds,
    );
  }

  Map<String, dynamic> toMap() => {
        ...toBaseMap(),
        'firstName': firstName,
        'lastName': lastName,
        'contactNumber': contactNumber,
        'gender': gender,
        'address': address,
        'birthDate': birthDate,
        'latitude': latitude,
        'longitude': longitude,
        'completedEvents': completedEvents,
        'joinedEvents': joinedEvents,
      };

  @override
  Volunteer copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? contactNumber,
    String? gender,
    String? address,
    DateTime? birthDate,
    double? latitude,
    double? longitude,
    int? completedEvents,
    String? profileUrl,
    List<String>? joinedEvents,
  }) {
    return Volunteer(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      contactNumber: contactNumber ?? this.contactNumber,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      completedEvents: completedEvents ?? this.completedEvents,
      profileUrl: profileUrl ?? this.profileUrl,
      joinedEvents: joinedEvents ?? this.joinedEvents,
    );
  }
}
