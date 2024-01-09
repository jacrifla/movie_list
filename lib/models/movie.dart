class Movie {
  int? id;
  String title;
  bool watched;
  String? posterUrl;

  Movie({
    this.id,
    required this.title,
    this.watched = false,
    this.posterUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'watched': watched ? 1 : 0,
      'posterUrl': posterUrl,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      watched: map['watched'] == 1,
      posterUrl: map['posterUrl'],
    );
  }
}
