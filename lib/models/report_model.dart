class ReportModel {
  final int? id;
  final int personId;
  final String reporterAcademyName;
  final String? reporterAcademyContact;
  final String? academyOwnerName;
  final String statusGiven; // Status at time of report
  final String reason;
  final String? incidentDate; // ISO8601 string, optional

  ReportModel({
    this.id,
    required this.personId,
    required this.reporterAcademyName,
    this.reporterAcademyContact,
    this.academyOwnerName,
    required this.statusGiven,
    required this.reason,
    this.incidentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'person_id': personId,
      'reporter_academy_name': reporterAcademyName,
      'reporter_academy_contact': reporterAcademyContact,
      'academy_owner_name': academyOwnerName,
      'status_given': statusGiven,
      'reason': reason,
      'incident_date': incidentDate,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as int?,
      personId: map['person_id'] as int,
      reporterAcademyName: map['reporter_academy_name'] as String,
      reporterAcademyContact: map['reporter_academy_contact'] as String?,
      academyOwnerName: map['academy_owner_name'] as String?,
      statusGiven: map['status_given'] as String,
      reason: map['reason'] as String,
      incidentDate: map['incident_date'] as String?,
    );
  }
}