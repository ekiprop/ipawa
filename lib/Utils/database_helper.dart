import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ipawa/Models/pawa.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String pawaTable = 'pawa_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'pawas.db';

    // Open/create the database at a given path
    var pawasDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return pawasDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $pawaTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colDate TEXT)');
  }

  // Fetch Operation: Get all todo objects from database
  Future<List<Map<String, dynamic>>> getPawaMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');
    var result = await db.query(pawaTable, orderBy: '$colTitle ASC');
    return result;
  }

  // Insert Operation: Insert a todo object to database
  Future<int> insertPawa(Pawa pawa) async {
    Database db = await this.database;
    var result = await db.insert(pawaTable, pawa.toMap());
    return result;
  }

  // Update Operation: Update a todo object and save it to database
  Future<int> updatePawa(Pawa pawa) async {
    var db = await this.database;
    var result = await db.update(pawaTable, pawa.toMap(),
        where: '$colId = ?', whereArgs: [pawa.id]);
    return result;
  }

  Future<int> updatePawaCompleted(Pawa pawa) async {
    var db = await this.database;
    var result = await db.update(pawaTable, pawa.toMap(),
        where: '$colId = ?', whereArgs: [pawa.id]);
    return result;
  }

  // Delete Operation: Delete a todo object from database
  Future<int> deletePawa(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $pawaTable WHERE $colId = $id');
    return result;
  }

  // Get number of todo objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $pawaTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'todo List' [ List<Todo> ]
  Future<List<Pawa>> getPawaList() async {
    var pawaMapList = await getPawaMapList(); // Get 'Map List' from database
    int count =
        pawaMapList.length; // Count the number of map entries in db table

    List<Pawa> pawaList = List<Pawa>();
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      pawaList.add(Pawa.fromMapObject(pawaMapList[i]));
    }

    return pawaList;
  }
}
