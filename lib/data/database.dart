// ignore_for_file: avoid_print

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/movie.dart';

class DatabaseHelper {
// Constantes para os nomes das colunas
  static const String tableMovies = 'movies';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnWatched = 'watched';
  static const String columnPosterUrl = 'posterUrl';
  static const String columnReleased = 'released';
  static const String columnGenre = 'genre';
  static const String columnDirector = 'director';
  static const String columnPlot = 'plot';
  static const String columnAwards = 'awards';
  static const String columnRuntime = 'runtime';
  static const String columnImdbRating = 'imdbRating';
  static const String columnRating = 'rating';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'movies_database.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _createMoviesTable,
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _createMoviesTable(Database db, int version) async {
    if (version == 1) {
      await db.execute('''
        CREATE TABLE $tableMovies (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnTitle TEXT,
          $columnWatched INTEGER,
          $columnPosterUrl TEXT,
          $columnReleased TEXT,
          $columnGenre TEXT,
          $columnDirector TEXT,
          $columnPlot TEXT,
          $columnAwards TEXT,
          $columnRuntime TEXT,
          $columnImdbRating TEXT,
          $columnRating REAL
        )
      ''');
    }
  }

  Future<int> insertMovie(Movie movie) async {
    Database db = await instance.database;
    return await db.insert(tableMovies, movie.toMap());
  }

  Future<List<Movie>> getAllMovies() async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> maps = await db.rawQuery(
          'SELECT * FROM $tableMovies ORDER BY CASE WHEN $columnWatched = 1 THEN 1 ELSE 0 END ASC');

      return List.generate(maps.length, (index) {
        return Movie.fromMap(maps[index]);
      });
    } catch (e) {
      print('Error getting all movies: $e');
      rethrow;
    }
  }

  Future<int> updateMovie(Movie movie) async {
    Database db = await instance.database;
    return await db.update(
      tableMovies,
      movie.toMap(),
      where: '$columnId = ?',
      whereArgs: [movie.id],
    );
  }

  Future<void> deleteMovie(int id) async {
    Database db = await instance.database;
    await db.delete(
      tableMovies,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateMovieRating(int id, double rating) async {
    Database db = await instance.database;
    return await db.update(
      tableMovies,
      {'rating': rating},
      where: '$columnId =?',
      whereArgs: [id],
    );
  }
}
