// database_helper.dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal() {
    _initializeDatabase();
  }

  late Database _database;

  Future<void> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'person_database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE person(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER,
            mobileNo TEXT,
            email TEXT
          )
        ''');
      },
    );
  }
  Future<Database> get database async {
    if (_database != null) return _database;

    await _initializeDatabase();
    return _database;
  }

  // Future<Database> get database async {
  //   if (_database != null) return _database;
  //
  //   _database = await initDatabase();
  //   return _database;
  // }


  Future<int> insertPerson(Person person) async {
    final db = await database;
    return await db.insert('person', person.toMap());
  }

  Future<List<Person>> getAllPersons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('person');
    return List.generate(maps.length, (i) {
      return Person.fromMap(maps[i]);
    });
  }

  Future<int> updatePerson(Person person) async {
    final db = await database;
    return await db.update(
      'person',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  Future<int> deletePerson(int id) async {
    final db = await database;
    return await db.delete(
      'person',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}



// children: [
// IconButton(
// icon: Icon(Icons.edit),
// onPressed: () => _onEdit(person),
// ),
// IconButton(
// icon: Icon(Icons.delete),
// onPressed: () => _onDelete(person.id),
// ),