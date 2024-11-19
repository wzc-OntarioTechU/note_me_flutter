
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import 'note.dart';
import 'DatabaseHandler.dart';

class NewNote extends StatefulWidget {
  final Note? editableNote;

  const NewNote({super.key, this.editableNote});

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  int _selectedColor = Colors.white.value;
  String? _photoPath;
  late DatabaseHandler _dbHandler;

  @override
  void initState() {
    super.initState();
    _dbHandler = DatabaseHandler();

    // If editing an existing note, pre-fill fields
    if (widget.editableNote != null) {
      _titleController.text = widget.editableNote!.title;
      _subtitleController.text = widget.editableNote!.subtitle;
      _bodyController.text = widget.editableNote!.body;
      _selectedColor = widget.editableNote!.colour;
      _photoPath = widget.editableNote!.photopath;
    }
  }

  Future<void> _saveNote() async {
    String title = _titleController.text.trim();
    String subtitle = _subtitleController.text.trim();
    String body = _bodyController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add a note title")),
      );
      return;
    }

    Note note = Note(
      id: widget.editableNote?.id,
      title: title,
      subtitle: subtitle,
      body: body,
      colour: _selectedColor,
      created: widget.editableNote?.created ?? DateTime.now(),
      photopath: _photoPath,
    );

    // TODO: Fix this method to navigate to the main activity
    if (widget.editableNote == null) {
      await _dbHandler.insertNote(note);

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewNote()));
    } else {
      await _dbHandler.updateNote(note);
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (image != null) {
  //     String filePath = await _saveImageToInternalStorage(image);
  //     setState(() {
  //       _photoPath = filePath;
  //     });
  //   }
  // }

  // Future<void> _takePhoto() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.camera);
  //
  //   if (image != null) {
  //     String filePath = await _saveImageToInternalStorage(image);
  //     setState(() {
  //       _photoPath = filePath;
  //     });
  //   }
  // }

  // Future<String> _saveImageToInternalStorage(XFile image) async {
  //   Directory appDir = await getApplicationDocumentsDirectory();
  //   String fileName = "image_${DateTime.now().millisecondsSinceEpoch}.jpg";
  //   String filePath = "${appDir.path}/$fileName";
  //
  //   final File newImage = await File(image.path).copy(filePath);
  //   return newImage.path;
  // }

  // Future<void> _deleteImage() async {
  //   if (_photoPath != null) {
  //     final File file = File(_photoPath!);
  //     if (await file.exists()) {
  //       await file.delete();
  //     }
  //     setState(() {
  //       _photoPath = null;
  //     });
  //   }
  // }

  // void _selectColor() async {
  //   Color? pickedColor = await showDialog<Color>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("Select Note Color"),
  //       content: SingleChildScrollView(
  //         child: BlockPicker(
  //           pickerColor: Color(_selectedColor),
  //           onColorChanged: (color) {
  //             Navigator.pop(context, color);
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   if (pickedColor != null) {
  //     setState(() {
  //       _selectedColor = pickedColor.value;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editableNote == null ? "New Note" : "Edit Note"),
        backgroundColor: Color(_selectedColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Container(
        color: Color(_selectedColor),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(
                labelText: "Subtitle",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: "Body",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            // SizedBox(height: 10),
            // if (_photoPath != null)
            //   Column(
            //     children: [
            //       Image.file(File(_photoPath!)),
            //       TextButton(
            //         onPressed: _deleteImage,
            //         child: Text("Remove Image"),
            //       ),
            //     ],
            //   ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     IconButton(
            //       icon: Icon(Icons.image),
            //       onPressed: _pickImage,
            //     ),
            //     IconButton(
            //       icon: Icon(Icons.camera),
            //       onPressed: _takePhoto,
            //     ),
            //     IconButton(
            //       icon: Icon(Icons.color_lens),
            //       onPressed: _selectColor,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
