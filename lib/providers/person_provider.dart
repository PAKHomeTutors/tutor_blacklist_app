import 'package:flutter/foundation.dart';
import '../models/person_model.dart';
import '../services/database_helper.dart';

class PersonProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<PersonModel> _persons = [];
  bool _isLoading = false;

  List<PersonModel> get persons => _persons;
  bool get isLoading => _isLoading;

  Future<void> loadAllPersons() async {
    _isLoading = true;
    notifyListeners();

    _persons = await _dbHelper.getAllPersons();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPerson(PersonModel person) async {
    await _dbHelper.insertPerson(person);
    await loadAllPersons(); // Refresh list
  }

  Future<void> updatePerson(PersonModel person) async {
    await _dbHelper.updatePerson(person);
    await loadAllPersons();
  }

  Future<void> deletePerson(int id) async {
    await _dbHelper.deletePerson(id);
    await loadAllPersons();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadAllPersons();
      return;
    }
    _isLoading = true;
    notifyListeners();

    _persons = await _dbHelper.searchPerson(query);

    _isLoading = false;
    notifyListeners();
  }
}