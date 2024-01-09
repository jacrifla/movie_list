import 'dart:convert';
import 'package:http/http.dart' as http;

class OmdbApiService {
  final String apiKey;
  final String baseUrl = 'http://www.omdbapi.com/';

  OmdbApiService(this.apiKey);

  Future<String?> getMoviePoster(String title) async {
    final response =
        await http.get(Uri.parse('$baseUrl?apikey=$apiKey&t=$title'));

    if (response.statusCode == 200) {
      Map<String, dynamic>? data = json.decode(response.body);
      return data?['Poster'];
    } else {
      throw Exception('Failed to load movie poster. Please try again later.');
    }
  }
}
