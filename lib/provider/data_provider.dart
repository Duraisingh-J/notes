// ignore_for_file: deprecated_member_use

import 'package:flutter/rendering.dart';
import 'package:notes/database/db_helper.dart';
import 'package:notes/models/note.dart';
import 'package:riverpod/riverpod.dart';

// ignore: subtype_of_sealed_class
class DataProvider extends StateNotifier<List<Note>> {
  DataProvider() : super([]) {
    loadNotes();
  }

  void loadNotes() async {
    final notes = await DBHelper().fetchNotes();
    state = notes.map((map) => Note.fromMap(map)).toList();
  }

  void addNote(Note note) {
    state = [...state, note];
  }

  void removeNote(note) {
    state = state.where((oldnote) => oldnote.id != note.id).toList();
  }

  void updateNote(Note updatenote) {
    state = [
      for (final note in state)
        if (note.id == updatenote.id) updatenote else note,
    ];
  }

  Future<String> seletedFilter(String value) async {
    final noteMaps = value == 'A-z'
        ? await DBHelper().fetchNotesbyAToZ()
        : value == 'Z-A'
        ? await DBHelper().fetchNotesbyZToA()
        : value == 'datecurToprev'
        ? await DBHelper().fetchNotesbyDateCurToPrev()
        : await DBHelper().fetchNotesbyDatePrevToCur();

    final filteredString = value == 'A-z'
        ? "Filtered by A-z"
        : value == 'Z-A'
        ? "Filtered by Z-A"
        : "Filtered by date \nfrom previous to current";
    state = noteMaps.map((map) => Note.fromMap(map)).toList();
    return filteredString;
  }
}

final dataProvider = StateNotifierProvider<DataProvider, List<Note>>(
  (ref) => DataProvider(),
);

final filterLabelProvider = StateProvider<String>((ref) { return 'No Filter is applied...';});
