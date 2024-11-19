import 'package:flutter/material.dart';
import 'note.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteTap;

  const NoteList({super.key, required this.notes, required this.onNoteTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () => onNoteTap(note),
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Allow dynamic height
                children: [
                  // Title
                  Text(
                    note.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // subtitle
                  if (note.subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        note.subtitle,
                      ),
                    ),

                  // Body
                  if (note.body.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        note.body,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "Created: ${_formatDate(note.created)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
