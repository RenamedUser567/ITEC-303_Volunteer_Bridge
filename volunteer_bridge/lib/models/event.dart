import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final String timeStart;
  final String timeEnd;
  final String location;
  final int volunteerLimit;
  final String bannerUrl;
  final String organizerId;
  final List<String> joinedVolunteers;
  final String tag;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.timeStart,
    required this.timeEnd,
    required this.location,
    required this.volunteerLimit,
    required this.bannerUrl,
    required this.organizerId,
    this.joinedVolunteers = const [],
    this.tag = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'start': Timestamp.fromDate(start),
      'end': Timestamp.fromDate(end),
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'location': location,
      'volunteerLimit': volunteerLimit,
      'bannerUrl': bannerUrl,
      'organizerId': organizerId,
      'joinedVolunteers': joinedVolunteers,
      'tag': tag,
    };
  }

  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      title: map['title'],
      description: map['description'],
      start: (map['start'] as Timestamp).toDate(),
      end: (map['end'] as Timestamp).toDate(),
      timeStart: map['timeStart'],
      timeEnd: map['timeEnd'],
      location: map['location'],
      volunteerLimit: map['volunteerLimit'],
      bannerUrl: map['bannerUrl'],
      organizerId: map['organizerId'],
      joinedVolunteers: List<String>.from(map['joinedVolunteers'] ?? []),
      tag: map['tag'],
    );
  }

  Event copyWith({
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    String? timeStart,
    String? timeEnd,
    String? location,
    int? volunteerLimit,
    String? bannerUrl,
    String? organizerId,
    List<String>? joinedVolunteers,
    String? tag,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      location: location ?? this.location,
      volunteerLimit: volunteerLimit ?? this.volunteerLimit,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      organizerId: organizerId ?? this.organizerId,
      joinedVolunteers: joinedVolunteers ?? this.joinedVolunteers,
      tag: tag ?? this.tag,
    );
  }
}
