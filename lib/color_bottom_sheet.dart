import 'package:flutter/material.dart';

class ColorBottomSheet extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorBottomSheet({Key? key, required this.onColorSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorButton(context, Colors.pink, 'Pink'),
              _buildColorButton(context, Colors.blue, 'Blue'),
              _buildColorButton(context, Colors.green, 'Green'),
              _buildColorButton(context, Colors.teal, 'Turquoise'),
              _buildColorButton(context, Colors.yellow, 'Yellow'),
            ],
          ),
          const SizedBox(height: 16),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: "Close",
          ),
        ],
      ),
    );
  }

  Widget _buildColorButton(BuildContext context, Color color, String label) {
    return GestureDetector(
      onTap: () {
        onColorSelected(color); // Call the callback function with the selected color
        Navigator.of(context).pop(); // Close the bottom sheet
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 24,
        child: Icon(Icons.check, color: Colors.white, size: 16),
      ),
    );
  }
}
