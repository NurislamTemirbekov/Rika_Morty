import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/character.dart';
import '../models/character_model.dart';
import 'character_remote_datasource.dart';

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  CharacterRemoteDataSourceImpl(this.client);

  @override
  Future<List<Character>> getCharacters(int page) async {
    final response = await client.get(
      Uri.parse('$baseUrl/character?page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = (data['results'] as List)
          .map((json) => CharacterModel.fromJson(json).toEntity())
          .toList();
      return results;
    } else {
      throw Exception('Failed to load characters: ${response.statusCode}');
    }
  }
}

