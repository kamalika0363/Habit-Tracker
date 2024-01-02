import "package:flutter/material.dart";

class MyAlertBox extends StatelessWidget {
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String hintText;

  const MyAlertBox(
      {
        super.key,
        this.controller,
        required this.onSave,
        required this.onCancel,
        required this.hintText
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Enter New Habit",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color.fromRGBO(97, 97, 97, 1)),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: onSave,
            color: Colors.black,
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
          MaterialButton(
            onPressed: onCancel,
            color: Colors.black,
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
