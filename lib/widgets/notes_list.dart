import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/widgets/notes.dart';

class NotesList extends StatelessWidget {
  final List<Note> noteList;
  const NotesList(this.noteList, {super.key});

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
        itemBuilder: (context, index) => Notes(noteList[index]),
      ),
    );
  }
}
