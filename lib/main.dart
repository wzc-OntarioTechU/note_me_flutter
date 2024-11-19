import 'package:flutter/material.dart';
import 'DatabaseHandler.dart'; // Custom database handler
import 'NewNote.dart'; // Page to add/edit notes
import 'note.dart'; // Note model

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure the DB binding has loaded
  runApp(const NoteMe());
}

class NoteMe extends StatelessWidget {
  const NoteMe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 240, 84, 110)),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DatabaseHandler _dbHandler;
  List<Note> _noteList = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _dbHandler = DatabaseHandler();
    _searchController = TextEditingController();
    _loadNotes(); // Load notes initially
  }

  Future<void> _loadNotes([String query = '']) async {
    List<Note> notes = query.isEmpty
        ? await _dbHandler.getAllNotes()
        : await _dbHandler.searchNotes(query);

    setState(() {
      _noteList = notes;
    });

    if (notes.isEmpty) {
      print("No notes found.");
    } else {
      for (var note in notes) {
        print("Note: ${note.title}");
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Color.fromARGB(255, 240, 84, 110),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // TextField(
            //   // controller: _searchController,
            //   // decoration: const InputDecoration(
            //   //   hintText: 'Search notes...',
            //   //   prefixIcon: Icon(Icons.search),
            //   // ),
            //   onChanged: (query) => _loadNotes(query),
            // ),
            const SizedBox(height: 10),
            Expanded(
              child: _noteList.isEmpty
                  ? Center(
                child: Text(
                  'No notes',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              )
                  : ListView.builder(
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  final note = _noteList[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.subject ?? 'No subject'),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewNote(editableNote: note),
                        ),
                      );
                      _loadNotes();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewNote()),
          );
          _loadNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
