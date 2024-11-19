import 'dart:io';

import 'package:flutter/material.dart';
import 'note.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteTap;

  const NoteList({Key? key, required this.notes, required this.onNoteTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        final accentColor = Color(note.colour).withOpacity(0.5);

        return GestureDetector(
          onTap: () => onNoteTap(note),
          child: Card(
            color: Color(note.colour),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (note.subtitle.isNotEmpty)
                    Text(
                      note.subtitle,
                      style: TextStyle(color: accentColor),
                    ),
                  if (note.body.isNotEmpty)
                    Text(
                      note.body,
                      style: TextStyle(color: accentColor),
                    ),
                  const SizedBox(height: 10),
                  if (note.photopath != null && note.photopath!.isNotEmpty)
                    _buildImage(note.photopath!),
                  Text(
                    "Created: ${_formatDate(note.created)}",
                    style: TextStyle(color: accentColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(String photoPath) {
    if (File(photoPath).existsSync()) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Image.file(
          File(photoPath),
          fit: BoxFit.cover,
          height: 150,
        ),
      );
    } else {
      return const SizedBox(); // Empty space if image file doesn't exist
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
