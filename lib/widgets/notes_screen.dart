import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/widgets/new_note.dart';
import 'package:notes/widgets/notes_list.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreen();
}

class _NotesScreen extends State<NotesScreen> {
  List<Note> notes = [
    Note(
      title: 'Physics',
      content: 'Gravitational Force',
      time: DateTime.now(),
    ),
    Note(title: 'Chemistry', content: 'Hybrid Bonding', time: DateTime.now()),
    Note(title: 'Nature', content: 'Nature evokes a wide range of thoughts, from wonder and awe to concern and responsibility. People often associate nature with beauty, tranquility, and the interconnectedness of all living things. Others see nature as a source of wisdom, inspiration, and even spiritual guidance. However, there\'s also a growing awareness of the importance of protecting nature, recognizing its fragility and the impact of human activities', time: DateTime.now())
  ];

  void _openToAddNote() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewNote(_addNote),
    );
  }

  void _addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: Column(
        children: [
          Expanded(child: NotesList(notes)),
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: _openToAddNote,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
