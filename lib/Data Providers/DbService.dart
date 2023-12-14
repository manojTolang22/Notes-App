import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';



/*This Dart class, DbService, represents a service for interacting with a 
SQLite database. It includes methods to configure the database, 
perform CRUD (Create, Read, Update, Delete) operations on a table 
named "Notes," and retrieve data from the database. */
class DbService {
  
  //These lines of code are implementing the Singleton design pattern in Dart.
  //Let me break it down for you:

  DbService._dbService() {}
  /*This is a private constructor for the DbService class. By making the constructor 
  private (using the underscore _ before its name), you prevent external code from 
  creating new instances of the DbService class directly. */

  static final DbService _service = DbService._dbService();
  /*This line creates a static, final instance of the DbService class named _service. 
  This instance is initialized by calling the private constructor _dbService(). */

  static DbService get singleInstance => _service;
  /* This is a static getter method named singleInstance that returns the _service instance.
   It provides access to the single instance of DbService and ensures that only one instance 
   of the class is created throughout the application. */

   /*By using the Singleton pattern, you ensure that there is only one instance of DbService 
   in your application. This can be beneficial for managing shared resources, such as a 
   database connection, across different parts of your code. */

  late Database SQFliteDb;
  final String _notesTable = "Notes";
  final int _dbVersion = 1;

  /// configure database
  /*
The configureDatabase method is responsible for setting up and configuring the SQLite database. 
Let's break down the key components: */
  configureDatabase() async {

    //Getting Directory Path:
    final dir = await getApplicationDocumentsDirectory();
    final db_Path = join(dir.path, "my_notes.db");
    /*getApplicationDocumentsDirectory(): This function is part of the path_provider 
    package and returns a Directory representing the path to the directory where 
    the application can store persistent data.

   join(dir.path, "my_notes.db"): This line constructs the full path to the SQLite 
   database file named "my_notes.db" within the application's documents directory. */

    //SQL Statement for Creating Notes Table:
    final String _createNoteTable = '''
                                  CREATE TABLE IF NOT EXISTS "$_notesTable"(
                                    id  INTEGER PRIMARY KEY AUTOINCREMENT,
                                    title VARCHAR(80),
                                    body  TEXT,
                                    createdAt VARCHAR,
                                    isDeleted NUMBER,
                                    deletedAt VARCHAR
                                  );''';
/*This is a SQL statement that creates the "Notes" table if it doesn't already exist.
The table has columns for id, title, body, createdAt, isDeleted, and deletedAt. 
The id is an auto-incremented primary key. */
     

    //Opening Database:
    final _db = await openDatabase(
      db_Path,
      version: _dbVersion,
      onConfigure: (db) {
        db.execute(_createNoteTable);
        debugPrint("Database created.....!!");
      },
    );
    /*openDatabase: This function is part of the sqflite package and is used to open or create an SQLite database.
      db_Path: The path to the SQLite database file. 
      version: The version number of the database.
      onConfigure: A callback function that is called when the database is opened. In this case,
      it executes the SQL statement to create the "Notes" table.*/


    //Assigning Database Instance:
    SQFliteDb = _db;
    /*Assigns the opened database instance _db to the SQFliteDb variable, 
    making it accessible for other methods in the DbService class. */

    /*This method ensures that the SQLite database is properly set up with the 
    required table when the application starts. If the database or table does 
    not exist, it creates them. If they already exist, it opens the existing 
    database. */
  }



// to get all notes
  Future<List<Map<String, Object?>>> getAllNotes() async {
    final res = await SQFliteDb.query(_notesTable, where: "isDeleted=false");
    return res;
  }
/*The method essentially fetches all non-deleted notes from the database and 
returns them as a list of maps. Each map contains the column names as keys 
and the corresponding values for a note. This information can then be used 
to construct Note objects or for further processing as needed in your 
application. */



  // to add new note into database
  /*The addNewNote method adds a new note to the "Notes" table in the SQLite database.  */
  Future<int> addNewNote(String title, String body) async {
    return await SQFliteDb.insert(_notesTable, {
      "title": title,
      "body": body,
      "createdAt": DateTime.now().toString(),
      "isDeleted": false
    });
  }
/*This method essentially inserts a new note with the provided 
title, body, and timestamp into the "Notes" table and returns 
the ID of the newly inserted row. The ID can be useful if you 
need to track or reference the newly added note. */



/*The updateExistingNote method updates an existing note in the 
"Notes" table of the SQLite database. Let's break down this method: */
  Future<int> updateExistingNote(int id, String? title, String? body) async {
    return await SQFliteDb.update(_notesTable,
        {"title": title, "body": body, "createdAt": DateTime.now().toString()},
        where: "id=?", whereArgs: [id]);
  }
  /*This method updates an existing note with the provided id, title, body, 
  and a new timestamp in the "Notes" table and returns the number of rows 
  that were successfully updated. */




  /*The deleteNote method deletes a note from the "Notes" table in the SQLite 
  database by marking it as deleted. */
  Future<int>  deleteNote(int id) async {
    return await SQFliteDb.update(
      _notesTable,
      {"isDeleted": true, "deletedAt": DateTime.now.toString()},
      where: "id=?",
      whereArgs: [id],
    );
  }
  /*This method updates a note with the provided id, marking it as deleted and 
  setting the deletion timestamp, and returns the number of rows that were 
  successfully updated. */
}
