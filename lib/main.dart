// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
// import 'data/database.dart';

void main() {
  runApp(const MyApp());
}

// void main() {
//   WidgetsFlutterBinding
//       .ensureInitialized(); // Garante que o Flutter esteja inicializado

//   // Chame o método para deletar todos os filmes depois de runApp()
//   runApp(const MyApp());
//   DatabaseHelper.instance
//       .deleteAllMovies(); // Certifique-se de chamar após runApp()
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
