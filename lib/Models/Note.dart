
/*The Note class is a Dart class representing a note with various properties.  */
class Note {
  final int id;
  final String title, body;
  final String createdAt;
  final String deletedAt;
  final bool isDeleted;


/*The Note class has the following properties:

id: The unique identifier of the note.
title: The title of the note.
body: The content or body of the note.
createdAt: The timestamp indicating when the note was created.
deletedAt: The timestamp indicating when the note was deleted.
isDeleted: A boolean flag indicating whether the note is marked as deleted. */

  Note(
      {required this.id,
      required this.title,
      required this.body,
      required this.createdAt,
      required this.deletedAt,
      required this.isDeleted});
  /*The constructor of the Note class is defined to initialize the 
  properties when creating an instance. */

  static Note formMap(Map map) {
    return Note(
        id: map['id'],
        title: map['title'] ?? " ",
        body: map['body'] ?? " ",
        createdAt: map['createdAt'] ?? " ",
        deletedAt: map['deletedAt'] ?? " ",
        isDeleted: map['isDeleted'] == 0 ? false : true);
  }
  /*The formMap method is a static factory method that takes a Map and 
  returns an instance of the Note class. It's used to convert a map 
  (often obtained from a database or API response) into a Note object. */

  static List<Note> formList(List<Map<String, Object?>> rawDatas) {
    return rawDatas.map((rawDatas) => formMap(rawDatas)).toList();
  }
  /*The formList method is another static factory method that takes a 
  list of maps and returns a list of Note objects. It uses formMap to 
  convert each map in the list. */

}


/*This class is designed to represent and handle note-related data,
providing methods for creating instances from raw data  */

