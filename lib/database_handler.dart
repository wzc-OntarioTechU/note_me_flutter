import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart'; // Assuming you have a Note class similar to your Java model

class DatabaseHandler {
  static const _databaseName = 'flutter_note.db';
  static const _databaseVersion = 1;

  static const tableNotes = 'notes';

  static final DatabaseHandler _instance = DatabaseHandler._privateConstructor();
  static Database? _database;

  DatabaseHandler._privateConstructor();

  factory DatabaseHandler() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableNotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        subtitle TEXT,
        body TEXT,
        created INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(tableNotes, note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableNotes);

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      tableNotes,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
