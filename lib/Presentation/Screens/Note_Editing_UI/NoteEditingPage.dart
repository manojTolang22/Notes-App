import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_notes/Data/Data%20Providers/DbService.dart';
import 'package:keep_notes/Data/Models/Note.dart';

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
    super.initState();
  }

  onButtonPressed() async {
    if (widget.note != null) {
      await db.updateExistingNote(widget.note!.id, _titleEditingController.text,
          _bodyEditingController.text);

      Navigator.pop(context);
    } else {
      await db.addNewNote(
          _titleEditingController.text, _bodyEditingController.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///app bar here
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
