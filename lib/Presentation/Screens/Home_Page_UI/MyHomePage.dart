import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_notes/Data/Data%20Providers/DbService.dart';
import 'package:keep_notes/Data/Models/Note.dart';
import 'package:keep_notes/Presentation/Screens/Note_Editing_UI/NoteEditingPage.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbService db = DbService.singleInstance;
  List<Note> allNotes = [];
  

  @override
  void initState() {
    super.initState();
    initilizeDbAndGetNotes();
  }

  initilizeDbAndGetNotes() async {
    await db.configureDatabase();
    getAllNotes();
  }

  getAllNotes() async {
    final res = await db.getAllNotes();
    allNotes = Note.formList(res);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App bar
      appBar: AppBar(
        title: Text(
          "All Notes",
          style: TextStyle(
              color: Colors.grey.shade500, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      ///List of notes
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                Note note = allNotes[index];
                final cccc = DateTime.parse(note.createdAt);
                String date = DateFormat.yMMMd().format(cccc);

                return InkWell(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(
                      builder: (context) {
                        return NoteEditingPage(
                          note: note,
                        );
                      },
                    )).then((value) => getAllNotes());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 24, top: 24, right: 24, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.title.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600),
                                    ),
                                    Text(
                                      note.body.toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade400),
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: () async {
                                      await db.deleteNote(note.id);
                                      getAllNotes();
                                    },
                                    icon: Icon(CupertinoIcons.trash_fill))
                              ],
                            ),
                            Text(
                              date,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        )),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "Empty..",
                style: TextStyle(
                  color: Colors.grey.shade400,
                ),
              ),
            ),

      //add new note to database
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(
            builder: (context) {
              return NoteEditingPage();
            },
          ))
          .then((value) => getAllNotes());
        },
        child: Icon(Icons.add),
      ),

      ///drawer box
      drawer: Drawer(
          child: ListView(
        children: [
          Container(
            height: 250,
            color: Colors.grey.shade50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_richtext,
                    size: 60,
                  ),
                  Text(
                    "Notes app",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
         
         
        
        ],
      )),
    );
  }
}
