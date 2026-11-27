import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/person_model.dart';
import '../models/contact_model.dart';
import '../models/report_model.dart';
import '../models/document_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tutor_blacklist.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        // Enable foreign keys in SQLite
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Persons table
    await db.execute('''
      CREATE TABLE persons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        father_name TEXT,
        cnic TEXT,
        address TEXT,
        role TEXT NOT NULL,
        overall_status TEXT NOT NULL
      )
    ''');

    // 2. Contacts table (Foreign Key -> persons)
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_id INTEGER NOT NULL,
        phone_number TEXT NOT NULL,
        is_primary INTEGER DEFAULT 0,
        FOREIGN KEY (person_id) REFERENCES persons (id) ON DELETE CASCADE
      )
    ''');

    // 3. Reports table (Foreign Key -> persons)
    await db.execute('''
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_id INTEGER NOT NULL,
        reporter_academy_name TEXT NOT NULL,
        reporter_academy_contact TEXT,
        academy_owner_name TEXT,
        status_given TEXT NOT NULL,
        reason TEXT NOT NULL,
        incident_date TEXT,
        FOREIGN KEY (person_id) REFERENCES persons (id) ON DELETE CASCADE
      )
    ''');

    // 4. Documents table (Foreign Key -> persons)
    await db.execute('''
      CREATE TABLE documents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_id INTEGER NOT NULL,
        document_type TEXT NOT NULL,
        file_name TEXT NOT NULL,
        cloudflare_url TEXT NOT NULL,
        FOREIGN KEY (person_id) REFERENCES persons (id) ON DELETE CASCADE
      )
    ''');
  }

  // ---------- PERSON CRUD ----------

  Future<int> insertPerson(PersonModel person) async {
    final db = await database;
    return await db.insert('persons', person.toMap());
  }

  Future<int> updatePerson(PersonModel person) async {
    final db = await database;
    return await db.update(
      'persons',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  Future<List<PersonModel>> getAllPersons() async {
    final db = await database;
    final maps = await db.query('persons', orderBy: 'full_name ASC');
    return maps.map((m) => PersonModel.fromMap(m)).toList();
  }

  /// Search by phone number OR CNIC.
  /// Joins contacts to find person by phone.
  Future<List<PersonModel>> searchPerson(String query) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT p.* FROM persons p
      LEFT JOIN contacts c ON c.person_id = p.id
      WHERE p.cnic LIKE ? OR p.full_name LIKE ? OR c.phone_number LIKE ?
    ''', ['%$query%', '%$query%', '%$query%']);
    return maps.map((m) => PersonModel.fromMap(m)).toList();
  }

  Future<PersonModel?> getPersonById(int id) async {
    final db = await database;
    final maps = await db.query('persons', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return PersonModel.fromMap(maps.first);
  }

  Future<int> deletePerson(int id) async {
    final db = await database;
    return await db.delete('persons', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- CONTACT CRUD ----------

  Future<int> insertContact(ContactModel contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<ContactModel>> getContactsForPerson(int personId) async {
    final db = await database;
    final maps = await db.query('contacts', where: 'person_id = ?', whereArgs: [personId]);
    return maps.map((m) => ContactModel.fromMap(m)).toList();
  }

  // ---------- REPORT CRUD ----------

  Future<int> insertReport(ReportModel report) async {
    final db = await database;
    return await db.insert('reports', report.toMap());
  }

  Future<List<ReportModel>> getReportsForPerson(int personId) async {
    final db = await database;
    final maps = await db.query('reports', where: 'person_id = ?', whereArgs: [personId], orderBy: 'id DESC');
    return maps.map((m) => ReportModel.fromMap(m)).toList();
  }

  // ---------- DOCUMENT CRUD ----------

  Future<int> insertDocument(DocumentModel document) async {
    final db = await database;
    return await db.insert('documents', document.toMap());
  }

  Future<List<DocumentModel>> getDocumentsForPerson(int personId) async {
    final db = await database;
    final maps = await db.query('documents', where: 'person_id = ?', whereArgs: [personId]);
    return maps.map((m) => DocumentModel.fromMap(m)).toList();
  }
}