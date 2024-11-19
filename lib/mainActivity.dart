import 'package:flutter/material.dart';
// Assuming sqflite for database
import 'DatabaseHandler.dart'; // Custom Dart equivalent of DatabaseHandler
import 'NewNote.dart';
// Page for adding/editing notes
import 'note.dart'; // Note model

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
        title: const Text('Notes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) => _loadNotes(query),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  final note = _noteList[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.subtitle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewNote(),
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
            MaterialPageRoute(builder: (context) => const NewNote()),
          ).then((_) => _loadNotes());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
