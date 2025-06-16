import 'package:flutter/material.dart';
import 'package:notes/database/db_helper.dart';
import 'package:notes/models/note.dart';
import 'package:notes/widgets/new_note.dart';
import 'package:notes/widgets/notes_list.dart';
import 'package:notes/widgets/search_screen.dart';

//Todo: create a search bar and also the filter
//      Customize the UI
//      Delete option
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreen();
}

class _NotesScreen extends State<NotesScreen> {
  List<Note>? _fetchedNotes;
  String filteredString = 'No Filter is applied...';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final noteMaps = await DBHelper().fetchNotes();
    setState(() {
      _fetchedNotes = noteMaps.map((map) => Note.fromMap(map)).toList();
    });
  }

  void _openToAddNote() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewNote(_loadNotes),
    );
  }

  void _removeNote(Note note) async {
    await DBHelper().deleteNote(note);
    _loadNotes();

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text("${note.title} is deleted"),
        action: SnackBarAction(
          onPressed: () async {
            await DBHelper().insertNote(note);
            _loadNotes();
          },
          label: "UNDO",
        ),
      ),
    );
  }

  void _moveToSearchScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SearchScreen(_fetchedNotes!, _loadNotes),
        transitionDuration: Duration(microseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.ease));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
          //return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _seletedFilter(String value) async {
    final noteMaps = value == 'A-z'
        ? await DBHelper().fetchNotesbyAToZ()
        : value == 'Z-A'
        ? await DBHelper().fetchNotesbyZToA()
        : value == 'datecurToprev'
        ? await DBHelper().fetchNotesbyDateCurToPrev()
        : await DBHelper().fetchNotesbyDatePrevToCur();

    setState(() {
      filteredString = value == 'A-z'
          ? "Filtered by A-z"
          : value == 'Z-A'
          ? "Filtered by Z-A"
          : "Filtered by date \nfrom previous to current";
      _fetchedNotes = noteMaps.map((map) => Note.fromMap(map)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget noteList;
    try {
      if (_fetchedNotes == null) {
        noteList = Center(child: CircularProgressIndicator());
      } else if (_fetchedNotes!.isEmpty) {
        noteList = Center(child: Text('No notes found'));
      } else {
        noteList = NotesList(_fetchedNotes!, _removeNote, _loadNotes);
      }
    } catch (e) {
      noteList = Center(child: Text('Error: $e'));
      print('$e');
    }
    final navigationBarlength = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Text(filteredString, style: TextStyle(fontSize: 20), ),
                Spacer(),
                PopupMenuButton(
                  onSelected: (value) => _seletedFilter(value),
                  icon: Icon(Icons.filter_list),
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem(value: 'A-z', child: Text('Sort by A-z')),
                    PopupMenuItem(value: 'Z-A', child: Text('Sort by Z-A')),
                    PopupMenuItem(
                      value: 'dateprevTocur',
                      child: Text('Sort by date (prev - cur)'),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _moveToSearchScreen,
                  icon: Icon(Icons.search),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 15),
            Expanded(child: noteList),
            Container(
              margin: navigationBarlength > 0
                  ? EdgeInsets.all(40)
                  : EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: _openToAddNote,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
