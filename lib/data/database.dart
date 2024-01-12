import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movies_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    if (version == 1) {
      await db.execute('''
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        watched INTEGER,
        posterUrl TEXT,
        released TEXT,
        genre TEXT,
        director TEXT,
        plot TEXT,
        awards TEXT,
        runtime TEXT,
        imdbRating TEXT,
        rating REAL
      )
    ''');
    }
  }

  Future<int> insertMovie(Movie movie) async {
    Database db = await instance.database;
    return await db.insert('movies', movie.toMap());
  }

  Future<List<Movie>> getAllMovies() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM movies ORDER BY CASE WHEN watched = 1 THEN 1 ELSE 0 END ASC');

    return List.generate(maps.length, (index) {
      return Movie.fromMap(maps[index]);
    });
  }

  Future<int> updateMovie(Movie movie) async {
    Database db = await instance.database;
    return await db.update(
      'movies',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Movie> getMovieById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps =
        await db.query('movies', where: 'id = ?', whereArgs: [id], limit: 1);

    if (maps.isNotEmpty) {
      return Movie.fromMap(maps.first);
    }
    throw Exception('Movie not found');
  }

  Future<int> deleteMovie(int id) async {
    Database db = await instance.database;
    return await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isMovieAlreadySaved(String title) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'movies',
      where: 'title = ?',
      whereArgs: [title],
    );
    return result.isNotEmpty;
  }

  Future<void> deleteMovieById(int id) async {
    Database db = await instance.database;
    await db.delete(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllMovies() async {
    Database db = await instance.database;
    await db.delete('movies');
  }

  Future<int> insertOrUpdateMovie(Movie movie) async {
    Database db = await instance.database;
    if (movie.id != null) {
      return await db.update('movies', movie.toMap(),
          where: 'id = ?', whereArgs: [movie.id]);
    } else {
      // Se o filme não existe
      return await db.insert('movies', movie.toMap());
    }
  }

  Future<int> updateMovieRating(int id, double rating) async {
    Database db = await instance.database;
    return await db.update(
      'movies',
      {'rating': rating},
      where: 'id =?',
      whereArgs: [id],
    );
  }
}
