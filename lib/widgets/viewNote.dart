import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class ViewNote extends StatefulWidget {
  final Note note;

  const ViewNote(this.note, {super.key});

  @override
  State<ViewNote> createState() => _ViewNote();
}

class _ViewNote extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          SizedBox(height: 70,),
          Align(alignment: Alignment.topLeft, child: Text(widget.note.title, style: TextStyle(fontSize: 35), )),
          Divider(thickness: 2,),
          Align(alignment: Alignment.topLeft,child: Text(widget.note.formattedTime.toString(), style: TextStyle(fontSize: 15),)),
          SizedBox(height: 30,),
          SingleChildScrollView(child: Text(widget.note.content, style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,)),

          ElevatedButton(onPressed: () {}, child: Text('Modify'))
        ],),
      ),
    );
  }
}
