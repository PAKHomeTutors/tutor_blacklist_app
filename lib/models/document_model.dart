class DocumentModel {
  final int? id;
  final int personId;
  final String documentType; // 'CNIC', 'CV', 'Degree'
  final String fileName;
  final String cloudflareUrl;

  DocumentModel({
    this.id,
    required this.personId,
    required this.documentType,
    required this.fileName,
    required this.cloudflareUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'person_id': personId,
      'document_type': documentType,
      'file_name': fileName,
      'cloudflare_url': cloudflareUrl,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] as int?,
      personId: map['person_id'] as int,
      documentType: map['document_type'] as String,
      fileName: map['file_name'] as String,
      cloudflareUrl: map['cloudflare_url'] as String,
    );
  }
}