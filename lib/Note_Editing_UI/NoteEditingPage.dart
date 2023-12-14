import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_notes/Data%20Providers/DbService.dart';
import 'package:keep_notes/Models/Note.dart';

class NoteEditingPage extends StatefulWidget {
  NoteEditingPage({super.key, this.note});

  final Note? note;

  @override
  State<NoteEditingPage> createState() => _NoteEditingPageState();
}

class _NoteEditingPageState extends State<NoteEditingPage> {

  DbService db = DbService.singleInstance;
  late TextEditingController _titleEditingController;
  late TextEditingController _bodyEditingController;

  @override
  void initState() {
    db.configureDatabase();
    _titleEditingController = TextEditingController();
    _bodyEditingController = TextEditingController();


    if (widget.note != null) {
      _titleEditingController = TextEditingController(text: widget.note!.title);
      _bodyEditingController = TextEditingController(text: widget.note!.body);
      return;
    }
    /*If a note is provided as a parameter to the widget, it means the user is 
    editing an existing note. In this case, the initial values of the title 
    and body controllers are set to the values of the existing note. 
    The return; statement is used to exit the method early in this case 
    since the initialization for editing is complete.If no note is provided, 
    the method continues with the regular initialization process. */

    super.initState();
  }


/*The onButtonPressed method is responsible for handling the logic when the user 
presses a button, and its behavior depends on whether the user is updating an 
existing note or adding a new one. */
  onButtonPressed() async {

    /*This condition checks if a note object is provided to the widget. 
    If it is, it means the user is editing an existing note.*/
    if (widget.note != null) {

      //Updating Existing Note:
      await db.updateExistingNote(widget.note!.id, _titleEditingController.text,
          _bodyEditingController.text);
      /*If editing an existing note, the updateExistingNote method of the db (database) 
      object is called. It's presumed that this method updates the existing note in 
      the database with the new title and body provided by the _titleEditingController 
      and _bodyEditingController. This operation is asynchronous, so await is used 
      to wait for its completion. */

      Navigator.pop(context);
      /*After updating the existing note, the screen is navigated back to the 
      previous screen (probably the list of all notes). */


    } else {

      //Adding a New Note:
      await db.addNewNote(
          _titleEditingController.text, _bodyEditingController.text);
      Navigator.pop(context);
      /*If not editing an existing note (i.e., adding a new note), the addNewNote 
      method of the db object is called. This method presumably adds a new note 
      to the database with the title and body provided by the controllers. 
      Similar to the editing case, the screen is navigated back to the previous 
      screen after adding a new note. */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///app bar here
      
      /* the AppBar dynamically adjusts its title based on whether the user is 
      adding a new note or updating an existing one. The leading icon (back arrow) 
      triggers the onButtonPressed method, which handles the logic for saving 
      or updating the note and navigating back. */
      appBar: AppBar(
        centerTitle: true,
        title: widget.note == null
            ? Text(
                "Add new note",
                style: TextStyle(color: Colors.grey.shade600),
              )
            : Text("Update note"),
        leading: IconButton(
            onPressed: () async {
              onButtonPressed();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),

      //body goes from here
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleEditingController,
              maxLength: 80,
              maxLines: 2,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  hintText: "Title",
                  border: InputBorder.none),
            ),
            Expanded(
              child: TextField(
                controller: _bodyEditingController,
                maxLength: 2000,
                maxLines: 1000,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    hintText: "Note",
                    border: InputBorder.none),
              ),
            )
          ],
        ),
      ),

      /*this bottomNavigationBar provides an alternative way for the user 
      to trigger the action of saving or updating a note. */
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoButton(
            borderRadius: BorderRadius.circular(24),
            color: Colors.deepPurple,
            child: Text(widget.note == null ? "Save me " : " Update me "),
            onPressed: () async {
              onButtonPressed();
            },
          )),
    );
  }
}
