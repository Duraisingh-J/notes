import 'package:flutter/material.dart';
import 'package:notes/database/db_helper.dart';
import 'package:notes/models/note.dart';
import 'package:notes/provider/data_provider.dart';
import 'package:notes/widgets/new_note.dart';
import 'package:notes/widgets/notes_list.dart';
import 'package:notes/screens/search_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Todo: create a search bar and also the filter
//      Customize the UI
//      Delete option
class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreen();
}

class _NotesScreen extends ConsumerState<NotesScreen> {
  List<Note>? fetchedNotes;

  void _openToAddNote() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewNote(),
    );
  }

  void _removeNote(Note note) async {
    ref.read(dataProvider.notifier).removeNote(note);
    await DBHelper().deleteNote(note);

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text("${note.title} is deleted"),
        action: SnackBarAction(
          onPressed: () async {
            await DBHelper().insertNote(note);
            ref.read(dataProvider.notifier).addNote(note);
          },
          label: "UNDO",
        ),
      ),
    );
  }

  void _moveToSearchScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
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

  @override
  Widget build(BuildContext context) {
    final fetchedNotes = ref.watch(dataProvider);
    Widget noteList;

    try {
      if (fetchedNotes.isEmpty) {
        noteList = Center(child: Text('No notes found'));
      } else {
        noteList = NotesList(fetchedNotes.cast<Note>(), _removeNote);
      }
    } catch (e) {
      noteList = Center(child: Text('Error: $e'));
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
                Text(
                  ref.watch(filterLabelProvider),
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                PopupMenuButton(
                  onSelected: (value) async {
                    final filteredString =
                        await ref.read(dataProvider.notifier).seletedFilter(value)
                            ;
                    ref.read(filterLabelProvider.notifier).state = filteredString;
                  },
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
