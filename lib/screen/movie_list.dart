// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:save_movies/screen/movie_details.screen.dart';
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
            title: Text('Warning'),
            content: Text("This movie is already on the list."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
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
          title: Text('Confirm deletion'),
          content: Text('Are you sure you want to delete this movie?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteMovieById(movieId);
                await refreshMovieList();
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
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
                                ListTile(
                                  leading: Image.network(
                                    (movie.posterUrl != 'N/A')
                                        ? movie.posterUrl!
                                        : 'https://m.media-amazon.com/images/M/MV5BNTNiOWJjMjYtYWFlYS00OGFkLTlhMDktNjQ5ZGViYTYyMTY4XkEyXkFqcGdeQXVyNTkyNjA2MTQ@._V1_SX300.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(movie.title),
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
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
                      title: Text('Add Movie'),
                      content: TextField(
                        onChanged: (value) {
                          newMovieTitle = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter movie title...',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (newMovieTitle.isNotEmpty) {
                              _addMovie(newMovieTitle);
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
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
