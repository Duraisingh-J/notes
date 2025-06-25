import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/note.dart';
import 'package:notes/provider/data_provider.dart';
import 'package:notes/widgets/notes.dart';

// ignore: must_be_immutable
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends ConsumerState<SearchScreen> {
  final TextEditingController _inputController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  List<Note>? fetchedNotes;
  List<Note> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    fetchedNotes = [];
    filteredNotes = [];
    _inputController.addListener(_searchingNotes);
  }

  void _searchingNotes() {
    final query = _inputController.text.toLowerCase();

    setState(() {
      filteredNotes = fetchedNotes!
          .where((item) => item.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    fetchedNotes = ref.watch(dataProvider);
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      cursorColor: isDarkMode
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColorDark,
                      autofocus: true,
                      controller: _inputController,
                      decoration: InputDecoration(
                        hint: Row(
                          children: [
                            Icon(Icons.search),
                            SizedBox(width: 5),
                            Text('Type here to search notes....'),
                          ],
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              filteredNotes.isEmpty
                  ? Center(child: Text('No Notes are found...'))
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) =>
                            Notes(filteredNotes[index]),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
