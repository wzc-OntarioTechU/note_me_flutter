import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Assuming sqflite for database
import 'DatabaseHandler.dart'; // Custom Dart equivalent of DatabaseHandler
import 'NewNote.dart';
import 'new_note_page.dart'; // Page for adding/editing notes
import 'note.dart'; // Note model

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DatabaseHandler _dbHandler;
  late List<Note> _noteList;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _dbHandler = DatabaseHandler();
    _searchController = TextEditingController();
    _loadNotes(); // Load notes initially
  }

  void _loadNotes([String query = '']) async {
    final notes = query.isEmpty
        ? await _dbHandler.getAllNotes()
        : await _dbHandler.searchNotes(query);
    setState(() {
      _noteList = notes;
    });
  }

  @override
  void dispose() {
   // _dbHandler.close(); // Close the database when the page is disposed
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) => _loadNotes(query),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  final note = _noteList[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewNotePage(note: note),
                        ),
                      ).then((_) => _loadNotes());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewNotePage()),
          ).then((_) => _loadNotes());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
