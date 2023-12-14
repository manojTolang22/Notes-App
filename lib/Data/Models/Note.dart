class Note {
  final int id;
  final String title, body;
  final String createdAt;
  final String deletedAt;
  final bool isDeleted;

  Note(
      {required this.id,
      required this.title,
      required this.body,
      required this.createdAt,
      required this.deletedAt,
      required this.isDeleted});

  static Note formMap(Map map) {
    return Note(
        id: map['id'],
        title: map['title'] ?? " ",
        body: map['body'] ?? " ",
        createdAt: map['createdAt'] ?? " ",
        deletedAt: map['deletedAt'] ?? " ",
        isDeleted: map['isDeleted'] == 0 ? false : true);
  }

  static List<Note> formList(List<Map<String, Object?>> rawDatas) {
    return rawDatas.map((rawDatas) => formMap(rawDatas)).toList();
  }
}

class Person {
  final int id;
  final String name;
  final String city;

  Person({required this.id, required this.name, required this.city});

  static Person formMap(Map map) {
    return Person(id: map['id'], name: map['name'], city: map['city']);
  }

  static List<Person> formList(List<Map<String, Object?>> rawData) {
    return rawData.map((e) => formMap(e)).toList();
  }
}
