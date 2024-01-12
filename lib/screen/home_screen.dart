// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'movie_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MovieList(),
    );
  }
}
