// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:save_movies/models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Details'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    '${movie.posterUrl}',
                    width: 300,
                    height: 450,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    '${movie.title}',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail(
                        'Director:', movie.director ?? 'Não disponível'),
                    _buildDetail('Genre:', movie.genre ?? 'Não disponível'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail('Runtime:', movie.runtime ?? 'Não disponível'),
                    _buildDetail(
                        'Released:', movie.released ?? 'Não disponível'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail('Awards:', movie.awards ?? 'Não disponível'),
                    _buildDetail(
                        'IMDb Rating:', movie.imdbRating ?? 'Não disponível'),
                  ],
                ),
                _buildDetail('Plot:', movie.plot ?? 'Não disponível'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
