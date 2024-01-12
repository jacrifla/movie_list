class Movie {
  int? id;
  String title;
  bool watched;
  String? posterUrl;
  String? released;
  String? genre;
  String? director;
  String? plot;
  String? awards;
  String? runtime;
  String? imdbRating;
  double? rating;

  Movie({
    this.id,
    required this.title,
    this.watched = false,
    this.posterUrl,
    this.released,
    this.genre,
    this.director,
    this.plot,
    this.awards,
    this.runtime,
    this.imdbRating,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'watched': watched ? 1 : 0,
      'posterUrl': posterUrl,
      'released': released,
      'genre': genre,
      'director': director,
      'plot': plot,
      'awards': awards,
      'runtime': runtime,
      'imdbRating': imdbRating,
      'rating': rating,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      watched: map['watched'] == 1,
      posterUrl: map['posterUrl'],
      released: map['released'],
      genre: map['genre'],
      director: map['director'],
      plot: map['plot'],
      awards: map['awards'],
      runtime: map['runtime'],
      imdbRating: map['imdbRating'],
      rating: map['rating'],
    );
  }
}
