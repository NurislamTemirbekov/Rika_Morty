import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  static Future<Map<String, dynamic>> getCharacters(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/character?page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = (data['results'] as List)
          .map((json) => Character.fromJson(json))
          .toList();

      return {
        'characters': results,
        'hasNext': data['info']['next'] != null,
      };
    } else {
      throw Exception('Failed to load characters');
    }
  }
}

