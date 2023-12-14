import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DbService {
  DbService._dbService() {}
  static final DbService _service = DbService._dbService();
  static DbService get singleInstance => _service;
  late Database SQFliteDb;
  final String _notesTable = "Notes";
  final int _dbVersion = 1;

  /// configure database
  configureDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final db_Path = join(dir.path, "my_notes.db");
    final String _createNoteTable = '''
                                  CREATE TABLE IF NOT EXISTS "$_notesTable"(
                                    id  INTEGER PRIMARY KEY AUTOINCREMENT,
                                    title VARCHAR(80),
                                    body  TEXT,
                                    createdAt VARCHAR,
                                    isDeleted NUMBER,
                                    deletedAt VARCHAR
                                  );''';

    final _db = await openDatabase(
      db_Path,
      version: _dbVersion,
      onConfigure: (db) {
        db.execute(_createNoteTable);
        debugPrint("Database created.....!!");
      },
    );
    SQFliteDb = _db;
  }

// to get all notes
  Future<List<Map<String, Object?>>> getAllNotes() async {
    final res = await SQFliteDb.query(_notesTable, where: "isDeleted=false");
    return res;
  }



  // to add new note into database
  Future<int> addNewNote(String title, String body) async {
    return await SQFliteDb.insert(_notesTable, {
      "title": title,
      "body": body,
      "createdAt": DateTime.now().toString(),
      "isDeleted": false
    });
  }

  //to update exixting/not deleted note
  Future<int> updateExistingNote(int id, String? title, String? body) async {
    return await SQFliteDb.update(_notesTable,
        {"title": title, "body": body, "createdAt": DateTime.now().toString()},
        where: "id=?", whereArgs: [id]);
  }

  //to store note into the trash been
  Future<int>  deleteNote(int id) async {
    return await SQFliteDb.update(
      _notesTable,
      {"isDeleted": true, "deletedAt": DateTime.now.toString()},
      where: "id=?",
      whereArgs: [id],
    );
  }

  /// delete delete permanently
  // Future<int> deletNotePermanently(int id) async {
  //   return await SQFliteDb.delete(_notesTable, where: "id=?", whereArgs: [id]);
  // }

// //to recycle the deleted note
//   Future<int> recycleTheDeletedNote(int id) async {
//     return await SQFliteDb.update(_notesTable,
//         {"isDeleted": false, "createdAt": DateTime.now().toString()},
//         where: "id=?", whereArgs: [id]);
//   }
}

// class DbServiceClass {
//   Future<Database> getDatabaseInstance() async {
//     final directory = await getApplicationDocumentsDirectory();
//     String path = join(directory.path, "person.db");
//     return await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute(''' CREATE TABLE IF NOT EXISTS Person(
//                          id  INTEGER PRIMARY KEY AUTOINCREMENT,
//                           name VARCHAR(80),
//                           city  TEXT
//                                     );''');
//     });
//   }
// }
