import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_notes/Data%20Providers/DbService.dart';
import 'package:keep_notes/Models/Note.dart';
import 'package:keep_notes/Note_Editing_UI/NoteEditingPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbService db = DbService.singleInstance;
  /* The line DbService db = DbService.singleInstance; 
creates an instance of the DbService class using 
a static method or property named singleInstance.
This suggests that you might be implementing a 
Singleton pattern for your DbService. The Singleton 
pattern ensures that a class has only one instance 
and provides a global point of access to that instance. */

  List<Note> allNotes = [];
  /*The line List<Note> allNotes = []; declares a list named 
  allNotes that will hold elements of type Note. */

  @override
  void initState() {
    super.initState();
    initilizeDbAndGetNotes();
  }

  /*the initState method is part of a Flutter StatefulWidget. 
  This method is called when the state of the widget is initialized, 
  typically before the widget is inserted into the widget tree. */

/*The initilizeDbAndGetNotes() method appears to be an asynchronous 
method that initializes a database and retrieves all notes. */
  initilizeDbAndGetNotes() async {
    await db.configureDatabase();
    /*await db.configureDatabase(): This line uses the await keyword 
    to wait for the completion of the configureDatabase method of the db object. */

    getAllNotes();
    /* This line calls the getAllNotes method. method that retrieves all notes,
    from the configured database.  */
  }

/*The getAllNotes method is another asynchronous method that 
retrieves notes from the database.  */
  getAllNotes() async {
    final res = await db.getAllNotes();
    allNotes = Note.formList(res);
    setState(() {});
  }
  /*the purpose of getAllNotes is to asynchronously retrieve notes 
  from the database, convert them into Note objects, update the 
  allNotes variable, and trigger a widget rebuild using setState */

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

/*The body property is set to a conditional expression that checks 
whether the allNotes list is not empty.

If allNotes is not empty (allNotes.isNotEmpty), 
a ListView.builder is used to build a scrollable list of notes. 
The itemBuilder callback is called for each item in the list. 

If allNotes is empty, a Center widget displays the text "Empty.." 
to indicate that there are no notes.*/

      ///List of notes
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {

                Note note = allNotes[index];
                /*This line retrieves the note at the specified index from the 
                allNotes list. It assumes that allNotes is a list of Note objects. */

                final cccc = DateTime.parse(note.createdAt);
                /*This line extracts the createdAt property from the note object 
                and converts it into a DateTime object using DateTime.parse.  */

                String date = DateFormat.yMMMd().format(cccc);
                /*This line formats the DateTime object (cccc) into a human-readable 
                string using the DateFormat.yMMMd() format. The resulting formatted 
                date is stored in the variable date. */

/*Each item in the list is represented by a Container wrapped in an InkWell. 
The onTap callback of InkWell navigates to the NoteEditingPage when the user 
taps on a note. */
                return InkWell(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(
                      builder: (context) {
                        return NoteEditingPage(
                          note: note,
                        );
                      },
                    )).then((value) => getAllNotes());
                    /*.then((value) => getAllNotes()): This part is a callback 
                    that is executed when the NoteEditingPage is popped from 
                    the navigation stack (when the user navigates back from 
                    NoteEditingPage). It calls the getAllNotes method, 
                    presumably to refresh the list of notes in the current screen. */
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
                                /*this code segment represents a delete button (trash can icon) 
                                    associated with each note. When pressed, it deletes the corresponding 
                                    note from the database and refreshes the list of notes on the screen. */
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
          )).then((value) => getAllNotes());
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
