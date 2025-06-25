import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/database/db_helper.dart';
import 'package:notes/models/note.dart';
import 'package:notes/provider/data_provider.dart';

class ViewNoteScreen extends ConsumerStatefulWidget {
  Note note;
  ViewNoteScreen(this.note, {super.key});

  @override
  ConsumerState<ViewNoteScreen> createState() => _ViewNote();
}

class _ViewNote extends ConsumerState<ViewNoteScreen> {
  bool isEditable = false;

  late TextEditingController _titleEditor;
  late TextEditingController _contentEditor;

  @override
  void initState() {
    super.initState();
    _titleEditor = TextEditingController(text: widget.note.title);
    _contentEditor = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleEditor.dispose();
    _contentEditor.dispose();

    super.dispose();
  }

  void updateNote() async {
    final updatedNote = Note.withId(
      id: widget.note.id,
      title: _titleEditor.text,
      content: _contentEditor.text,
      time: DateTime.now(),
    );
    await DBHelper().updateNote(updatedNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Note is modified'),
      ),
    );
   
    ref.read(dataProvider.notifier).updateNote(updatedNote);
    setState(() {
       widget.note = updatedNote;
      isEditable = false;
    });
  }

  Widget editNote() {
    return SafeArea(
      child: 
      LayoutBuilder(
        builder: (context, constraints) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: TextField(
                      cursorColor: Colors.black,
                      enabled: true,
                      autofocus: true,
                      controller: _titleEditor,
                      maxLines: null,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    height: isPortrait
                        ? MediaQuery.of(context).size.height * 0.65
                        : MediaQuery.of(context).size.height * 0.50,
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: _contentEditor,
                      style: TextStyle(fontSize: 20),
                      maxLines: null,
                      decoration: InputDecoration(
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
                          setState(() {
                            isEditable = false;
                          });
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          updateNote();
                        },
                        child: Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (isEditable) {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Text('Discard note changes?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditable = false;
                      });
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text(
                      'Discard Changes',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: isEditable
              ? editNote()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(height: isPortrait ? 30 : 20),
                        Text(widget.note.title, style: TextStyle(fontSize: 35)),
                        Divider(thickness: 2),
                        Text(
                          widget.note.formattedTime.toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 30),
                        SingleChildScrollView(
                          child: Text(
                            widget.note.content,
                            style: TextStyle(fontSize: 20),

                            textAlign: widget.note.content.length > 5
                                ? TextAlign.justify
                                : TextAlign.start,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEditable = true;
                            });
                          },
                          child: Text('Edit'),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
