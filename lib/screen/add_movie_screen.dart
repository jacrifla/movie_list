// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import '../data/database.dart';
import '../models/movie.dart';
import '../utils/string_utils.dart';

class AddMovieScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();

  AddMovieScreen({super.key});

  void _addMovie(BuildContext context) async {
    if (_titleController.text.isNotEmpty) {
      String originalTitle = _titleController.text;

      String title = toCamelCase(originalTitle);

      Movie newMovie = Movie(title: title, watched: false);

      await DatabaseHelper.instance.insertMovie(newMovie);

      Navigator.pop(context); // Volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Movie'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Movie Title'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _addMovie(context);
            },
            child: Text('Add Movie'),
          ),
        ],
      ),
    );
  }
}
