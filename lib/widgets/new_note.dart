import 'package:flutter/material.dart';
import 'package:notes/database/db_helper.dart';
import 'package:notes/models/note.dart';

// ignore: must_be_immutable
class NewNote extends StatefulWidget {
  void Function() addNote;
  NewNote(this.addNote, {super.key});

  @override
  State<StatefulWidget> createState() => _NewNote();
}

class _NewNote extends State<NewNote> {
  final _titlecontroller = TextEditingController();
  final _contentcontroller = TextEditingController();

  @override
  void dispose() {
    _titlecontroller.dispose();
    _contentcontroller.dispose();
    super.dispose();
  }

  Future<void> _submitNote() async {
    if (_titlecontroller.text.trim().isEmpty ||
        _contentcontroller.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('No input'),
          content: Text('Please make sure to enter the title and content'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final newNote = Note(
      title: _titlecontroller.text.trim(),
      content: _contentcontroller.text.trim(),
      time: DateTime.now(),
    );

    try {
      await DBHelper().insertNote(newNote);
      widget.addNote();
      Navigator.pop(context);
    } catch (e) {
      print("Insert error: $e");
      if (context.mounted) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Error"),
            content: Text("Could not save the note"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            child: TextField(
              controller: _titlecontroller,
              maxLines: null,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'TITLE',
                hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: isDarkMode
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(10),
            ),
            height: MediaQuery.of(context).size.height * 0.65,
            child: TextField(
              controller: _contentcontroller,
              style: TextStyle(fontSize: 20),
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Type your note...',
                hintStyle: TextStyle(fontSize: 15),
                border: InputBorder.none,

                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(width: 1),
                // ),
                // focusedBorder: OutlineInputBorder(
                //   borderSide: BorderSide(width: 2),
                // ),
              ),
            ),
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              SizedBox(width: 10),
              ElevatedButton(onPressed: _submitNote, child: Text('Add')),
            ],
          ),
        ],
      ),
    );
  }
}
