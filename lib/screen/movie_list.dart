// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:save_movies/screen/movie_details.screen.dart';
import 'package:save_movies/utils/string_utils.dart';
import '../data/database.dart';
import '../models/movie.dart';
import '../services/omdb_api_service.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late Future<List<Movie>> movies;

  @override
  void initState() {
    super.initState();
    refreshMovieList();
  }

  Future<void> refreshMovieList() async {
    setState(() {
      movies = DatabaseHelper.instance.getAllMovies();
    });
  }

  Future<void> _addMovie(String title) async {
    List<Movie> movies = await DatabaseHelper.instance.getAllMovies();

    bool filmeExiste =
        movies.any((movie) => movie.title.toLowerCase() == title.toLowerCase());

    if (filmeExiste) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Warning',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.cyan[900], fontWeight: FontWeight.bold),
            ),
            content: Text(
              "This movie is already on the list.",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      Map<String, dynamic>? movieDetails =
          await OmdbApiService('e5f48ed3').getMovieDetailsAll(title);

      if (movieDetails != null) {
        String? posterUrl = movieDetails['Poster'];
        String? released = movieDetails['Released'];
        String? genre = movieDetails['Genre'];
        String? director = movieDetails['Director'];
        String? plot = movieDetails['Plot'];
        String? awards = movieDetails['Awards'];
        String? runtime = movieDetails['Runtime'];
        String? imdbRating = movieDetails['imdbRating'];

        if (posterUrl != null &&
            released != null &&
            genre != null &&
            director != null &&
            plot != null &&
            awards != null &&
            runtime != null &&
            imdbRating != null) {
          Movie newMovie = Movie(
            title: title,
            posterUrl: posterUrl,
            released: released,
            genre: genre,
            director: director,
            plot: plot,
            awards: awards,
            runtime: runtime,
            imdbRating: imdbRating,
          );

          await DatabaseHelper.instance.insertMovie(newMovie);
          await refreshMovieList();
          setState(() {});

          print('Detalhes do filme adicionado:');
          print('Título: $title');
          print('URL do pôster: $posterUrl');
          // ... imprimir outros detalhes do filme
        } else {
          print('Falha ao obter detalhes do filme: $title');
        }
      } else {
        print('Falha ao obter detalhes do filme: $title');
      }
    }
  }

  Future<void> _confirmarExclusao(int movieId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm deletion',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.cyan[900], fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete this movie?',
            style: TextStyle(color: Colors.cyan[900]),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteMovieById(movieId);
                    await refreshMovieList();
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: movies,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.cyan[100],
          appBar: AppBar(
            title: Text(
              'Movie List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.cyan[50],
              ),
            ),
            backgroundColor: Colors.cyan,
            centerTitle: true,
          ),
          body: (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 80),
                  child: ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      Movie movie = snapshot.data![index];
                      return Column(
                        children: [
                          GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsScreen(
                                    movie: movie,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: Offset(0, 2),
                                        ),
                                      ]),
                                  child: ListTile(
                                    leading: Image.network(
                                      (movie.posterUrl != 'N/A')
                                          ? movie.posterUrl!
                                          : 'https://m.media-amazon.com/images/M/MV5BNTNiOWJjMjYtYWFlYS00OGFkLTlhMDktNjQ5ZGViYTYyMTY4XkEyXkFqcGdeQXVyNTkyNjA2MTQ@._V1_SX300.jpg',
                                      fit: BoxFit.cover,
                                      width: 50,
                                    ),
                                    title: Text(toCamelCase(movie.title)),
                                    trailing: Checkbox(
                                      side: BorderSide(
                                          color: Colors.cyan, width: 2),
                                      activeColor: Colors.cyan[900],
                                      value: movie.watched,
                                      onChanged: (value) async {
                                        movie.watched = value!;
                                        await DatabaseHelper.instance
                                            .updateMovie(movie);
                                        setState(() {});
                                      },
                                    ),
                                    onLongPress: () async {
                                      await _confirmarExclusao(movie.id!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    late String newMovieTitle;
                    return AlertDialog(
                      title: Text(
                        'Add Movie',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.cyan[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: TextField(
                        onChanged: (value) {
                          newMovieTitle = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter movie title...',
                          hintStyle: TextStyle(
                            color: Colors.cyan[500],
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 1, 157, 177),
                                width: 2.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 188, 212),
                                width: 1.0),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.cyan[200],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (newMovieTitle.isNotEmpty) {
                                  _addMovie(newMovieTitle);
                                }
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.cyan[700],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              label: Text(
                'Add Movie',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.cyan,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
