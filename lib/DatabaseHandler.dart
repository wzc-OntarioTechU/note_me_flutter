import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart'; // Assuming you have a Note class similar to your Java model

class DatabaseHandler {
  static const _databaseName = 'notes.db';
  static const _databaseVersion = 3;

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
        colour INTEGER,
        created INTEGER,
        photopath TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE $tableNotes ADD COLUMN photopath TEXT');
    }
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

  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query(tableNotes, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
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

  Future<int> deleteNoteById(int id) async {
    final db = await database;
    return await db.delete(
      tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Note>> searchNotes(String filter) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableNotes,
      where: 'title LIKE ?',
      whereArgs: ['%$filter%'],
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
