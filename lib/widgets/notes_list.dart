import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/widgets/notes.dart';

// ignore: must_be_immutable
class NotesList extends StatelessWidget {
  final List<Note> noteList;
  final Function(Note) removeNote;
  void Function() loadNotes;
  NotesList(this.noteList, this.removeNote, this.loadNotes, {super.key});

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //   itemCount: noteList.length,
    //   itemBuilder: (context, index) =>
    //     Notes(noteList[index])
    //   ,
    // );
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: noteList.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(noteList[index]),
          onDismissed: (direction) {
            removeNote(noteList[index]);
          },
          child: Notes(noteList[index], loadNotes),
        ),
      ),
    );
  }
}
