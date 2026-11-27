/// Data model representing a Person (Tutor or Client) in the blacklist system.
///
/// This class maps 1:1 to the `persons` table in SQLite.
/// A Person can have multiple Contacts, Reports, and Documents
/// (all linked via `person_id` foreign keys in their respective tables).
class PersonModel {
  /// Auto-incremented primary key. `null` when the person hasn't been
  /// inserted into the database yet.
  final int? id;

  /// Full name of the person (required).
  final String fullName;

  /// Father's name (optional).
  final String? fatherName;

  /// CNIC / National ID number (optional but used heavily for search).
  final String? cnic;

  /// Residential or academy address (optional).
  final String? address;

  /// Role of the person in the system.
  /// Expected values: 'Tutor' or 'Client'.
  final String role;

  /// Overall reputation status of the person.
  /// Expected values: 'Blacklisted', 'Greylisted', 'Greenlisted', 'Unverified'.
  final String overallStatus;

  const PersonModel({
    this.id,
    required this.fullName,
    this.fatherName,
    this.cnic,
    this.address,
    required this.role,
    required this.overallStatus,
  });

  // ---------------------------------------------------------------------------
  // SQLite serialization
  // ---------------------------------------------------------------------------

  /// Converts this model into a `Map<String, dynamic>` suitable for
  /// `db.insert()` and `db.update()` in `sqflite`.
  ///
  /// Column names use `snake_case` to match the SQL schema defined in
  /// `database_helper.dart`.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'father_name': fatherName,
      'cnic': cnic,
      'address': address,
      'role': role,
      'overall_status': overallStatus,
    };
  }

  /// Builds a [PersonModel] from a row returned by `sqflite`.
  ///
  /// Uses safe casting for nullable columns so that `null` values
  /// coming from the database don't throw a `TypeError`.
  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'] as int?,
      fullName: (map['full_name'] as String?) ?? '',
      fatherName: map['father_name'] as String?,
      cnic: map['cnic'] as String?,
      address: map['address'] as String?,
      role: (map['role'] as String?) ?? 'Tutor',
      overallStatus: (map['overall_status'] as String?) ?? 'Unverified',
    );
  }

  // ---------------------------------------------------------------------------
  // Utility
  // ---------------------------------------------------------------------------

  /// Returns a new [PersonModel] with the specified fields replaced.
  /// Useful for immutable updates in state management.
  PersonModel copyWith({
    int? id,
    String? fullName,
    String? fatherName,
    String? cnic,
    String? address,
    String? role,
    String? overallStatus,
  }) {
    return PersonModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      fatherName: fatherName ?? this.fatherName,
      cnic: cnic ?? this.cnic,
      address: address ?? this.address,
      role: role ?? this.role,
      overallStatus: overallStatus ?? this.overallStatus,
    );
  }

  @override
  String toString() {
    return 'PersonModel(id: $id, fullName: $fullName, role: $role, '
        'overallStatus: $overallStatus)';
  }
}