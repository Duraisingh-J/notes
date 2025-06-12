import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/models/note.dart';
import 'package:notes/widgets/viewNote.dart';

class Notes extends StatelessWidget {
  final Note note;
  const Notes(this.note, {super.key});

  void viewNote(context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ViewNote(note)));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return InkWell(
      onTap: () => viewNote(context),
      child: Card(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                // ignore: deprecated_member_use
                isDarkMode ? Theme.of(context).primaryColorDark.withOpacity(0.3) : Theme.of(context).colorScheme.primary.withOpacity(0), 
                // ignore: deprecated_member_use
                //Theme.of(context).colorScheme.primary.withOpacity(0.2),
                // ignore: deprecated_member_use
                isDarkMode? Theme.of(context).primaryColor.withOpacity(0.5) : Theme.of(context).colorScheme.primary.withOpacity(0.35),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    note.title,
                    style: GoogleFonts.ptSerif(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Divider(thickness: 2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(note.content, maxLines: 6),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    note.formattedTime,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
