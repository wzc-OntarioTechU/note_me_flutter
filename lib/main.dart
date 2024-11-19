import 'package:flutter/material.dart';
import 'database_handler.dart';
import 'new_note.dart';
import 'note.dart';
import 'note_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoteMe());
}

class NoteMe extends StatelessWidget {
  const NoteMe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 240, 84, 110)),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
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

  Future<void> _loadNotes() async {
    List<Note> notes = await _dbHandler.getAllNotes();

    setState(() {
      _noteList = notes;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleNoteTap(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewNote(editableNote: note),
      ),
    );
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: const Color.fromARGB(255, 240, 84, 110),
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
                  : NoteList(
                notes: _noteList,
                onNoteTap: _handleNoteTap,
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
