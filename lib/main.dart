import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'DatabaseHandler.dart';
import 'NewNote.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure that the db binding has loaded
  final database = openDatabase(
    join(await getDatabasesPath(), "notes.db"), // open/create the database file as notes.db
    onCreate: (db, version) {
      return db.execute("CREATE TABLE notes(id INTEGER PRIMARY KEY NOT NULL, title TEXT NOT NULL, subject TEXT, body TEXT, color INTEGER, photo_id_array TEXT);"
          "CREATE TABLE photos(id INTEGER PRIMARY KEY NOT NULL, data BLOB NOT NULL);");
    },
    version: 1 // since we are starting anew
  );
  runApp(const NoteMe());
}

class NoteMe extends StatelessWidget {
  const NoteMe({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(255, 128, 128, 255)),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Note Me'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int noteCount = 0;

  Future<void> refreshFromDB() async {
    final DatabaseHandler database = DatabaseHandler();
    final db = database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TODO: Add conditional Check
            Text(
              'No notes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewNote()),
          );
        },
        tooltip: 'Add a new note',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
