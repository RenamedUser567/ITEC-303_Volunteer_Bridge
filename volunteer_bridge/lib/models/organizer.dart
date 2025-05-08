class Organizer {
  final String id;
  final String companyName;
  final String contactNumber;
  final String address;
  final String companyDescription;
  final String email;

  Organizer({
    required this.id,
    required this.companyName,
    required this.contactNumber,
    required this.address,
    required this.companyDescription,
    required this.email,
  });

  factory Organizer.fromMap(String id, Map<String, dynamic> data) {
    return Organizer(
      id: id,
      companyName: data['companyName'],
      contactNumber: data['contactNumber'],
      address: data['address'],
      companyDescription: data['companyDescription'],
      email: data['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'contactNumber': contactNumber,
      'address': address,
      'companyDescription': companyDescription,
      'email': email,
    };
  }

  Organizer copyWith({
    String? id,
    String? companyName,
    String? contactNumber,
    String? address,
    String? companyDescription,
    String? email,
  }) {
    return Organizer(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      companyDescription: companyDescription ?? this.companyDescription,
      email: email ?? this.email,
    );
  }
}
