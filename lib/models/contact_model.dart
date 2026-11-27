class ContactModel {
  final int? id;
  final int personId;
  final String phoneNumber;
  final int isPrimary; // 0 or 1 for SQLite

  ContactModel({
    this.id,
    required this.personId,
    required this.phoneNumber,
    this.isPrimary = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'person_id': personId,
      'phone_number': phoneNumber,
      'is_primary': isPrimary,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as int?,
      personId: map['person_id'] as int,
      phoneNumber: map['phone_number'] as String,
      isPrimary: map['is_primary'] as int? ?? 0,
    );
  }
}