import 'package:notes/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        timestamp TEXT)
    ''');
  }

  Future<void> insertNote(Note note) async {
    final db = await database;

    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> printNotes() async {
    final db = await database;

    final results = await db.query('notes');

    // ignore: avoid_print
    print("Fetched ${results.length} notes");
    for (var result in results) {
      // ignore: avoid_print
      print(result);
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> notes = (await db.query(
      'notes',
    )).cast<Map<String, dynamic>>();
    return notes;
  }

  Future<List<Map<String, dynamic>>> fetchNotesbyAToZ() async {
    final db = await database;
    final List<Map<String, dynamic>> notes = (await db.query(
      'notes',
      orderBy: 'title ASC',
    )).cast<Map<String, dynamic>>();
    return notes;
  }

  Future<List<Map<String, dynamic>>> fetchNotesbyZToA() async {
    final db = await database;
    final List<Map<String, dynamic>> notes = (await db.query(
      'notes',
      orderBy: 'title DESC',
    )).cast<Map<String, dynamic>>();
    return notes;
  }

   Future<List<Map<String, dynamic>>> fetchNotesbyDateCurToPrev() async {
    final db = await database;
    final List<Map<String, dynamic>> notes = (await db.query(
      'notes',
      orderBy: 'timestamp DESC',
    )).cast<Map<String, dynamic>>();
    return notes;
  }

   Future<List<Map<String, dynamic>>> fetchNotesbyDatePrevToCur() async {
    final db = await database;
    final List<Map<String, dynamic>> notes = (await db.query(
      'notes',
      orderBy: 'timestamp ASC',
    )).cast<Map<String, dynamic>>();
    return notes;
  }

  

  

  Future<void> updateNote(Note note) async {
    final db = await database;

    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(Note note) async {
    final db = await database;

    await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
  }
}
