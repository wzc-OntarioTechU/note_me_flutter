import 'package:flutter/material.dart';
import 'note.dart';
import 'database_handler.dart';

class NewNote extends StatefulWidget {
  final Note? editableNote;
  const NewNote({super.key, this.editableNote});

  @override
  NewNoteState createState() => NewNoteState();
}

class NewNoteState extends State<NewNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  late DatabaseHandler _dbHandler;

  @override
  void initState() {
    super.initState();
    _dbHandler = DatabaseHandler();

    if (widget.editableNote != null) {
      _titleController.text = widget.editableNote!.title;
      _subtitleController.text = widget.editableNote!.subtitle;
      _bodyController.text = widget.editableNote!.body;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    String title = _titleController.text.trim();
    String subtitle = _subtitleController.text.trim();
    String body = _bodyController.text.trim();

    if (title.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please add a note title")),
        );
      }
      return;
    }

    Note note = Note(
      id: widget.editableNote?.id,
      title: title,
      subtitle: subtitle,
      body: body,
      created: widget.editableNote?.created ?? DateTime.now(),
    );

    if (widget.editableNote == null) {
      await _dbHandler.insertNote(note);
    } else {
      await _dbHandler.updateNote(note);
    }

    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editableNote == null ? "New Note" : "Edit Note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
                floatingLabelAlignment: FloatingLabelAlignment.start,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(
                labelText: "Subtitle",
                border: OutlineInputBorder(),
                floatingLabelAlignment: FloatingLabelAlignment.start,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: "Body",
                border: OutlineInputBorder(),
                floatingLabelAlignment: FloatingLabelAlignment.start,
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}