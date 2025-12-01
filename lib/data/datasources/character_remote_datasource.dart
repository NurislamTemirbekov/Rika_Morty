import '../../domain/entities/character.dart';

abstract class CharacterRemoteDataSource {
  Future<List<Character>> getCharacters(int page);
}

