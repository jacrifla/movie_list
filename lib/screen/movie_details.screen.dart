// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, library_private_types_in_public_api, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:save_movies/data/database.dart';
import 'package:save_movies/models/movie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:save_movies/utils/string_utils.dart';
import '../widget/build_detail.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  double currentRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Film Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.cyan,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(2, 1),
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black12),
            color: Colors.white),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      '${widget.movie.posterUrl}',
                      width: 300,
                      height: 450,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      '${toCamelCase(widget.movie.title)}',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: RatingBar.builder(
                        initialRating: widget.movie.rating ?? 0.0,
                        itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                        onRatingUpdate: onRatingUpdate),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildDetail(
                          'Director:', widget.movie.director ?? 'Not available',
                          alignment: CrossAxisAlignment.start),
                      buildDetail(
                          'Genre:', widget.movie.genre ?? 'Not available'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildDetail(
                          'Runtime:', widget.movie.runtime ?? 'Not available',
                          alignment: CrossAxisAlignment.start),
                      buildDetail('Released:',
                          widget.movie.released ?? 'Not available'),
                      buildDetail('IMDb Rating:',
                          widget.movie.imdbRating ?? 'Not available'),
                    ],
                  ),
                  buildDetail('Awards:', widget.movie.awards ?? 'Not available',
                      alignment: CrossAxisAlignment.start),
                  buildDetail('Plot:', widget.movie.plot ?? 'Not available',
                      alignment: CrossAxisAlignment.start),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onRatingUpdate(double rating) async {
    if (widget.movie.rating != rating) {
      setState(() {
        currentRating = rating;
        widget.movie.rating = rating;
      });
      await DatabaseHelper.instance.updateMovieRating(
        widget.movie.id!,
        rating,
      );
    }
  }
}
