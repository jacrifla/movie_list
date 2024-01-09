// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
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
            title: Text('Aviso'),
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
      String? posterUrl =
          await OmdbApiService('e5f48ed3').getMoviePoster(title);
      if (posterUrl != null) {
        Movie newMovie = Movie(title: title, posterUrl: posterUrl);
        await DatabaseHelper.instance.insertMovie(newMovie);
        await refreshMovieList();

        print('Detalhes do filme adicionado:');
        print('Título: $title');
        print('URL do pôster: $posterUrl');
      } else {
        print('Falha ao obter URL do poster para o filme: $title');
      }
    }
  }

  Future<void> _confirmarExclusao(int movieId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar exclusão'),
          content: Text('Você tem certeza que deseja excluir este filme?'),
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
              child: Text('Excluir'),
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
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Movie movie = snapshot.data![index];
                      return Column(
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
                              side: BorderSide(color: Colors.cyan, width: 2),
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
