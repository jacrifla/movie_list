// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:save_movies/models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                '${movie.posterUrl}',
                width: 300,
                height: 450,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Title: ${movie.title}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Released: ${movie.released}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Awards: ${movie.awards}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Director: ${movie.director}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Genre: ${movie.genre}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'IMDb Rating: ${movie.imdbRating}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Plot: ${movie.plot}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Runtime: ${movie.runtime}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
