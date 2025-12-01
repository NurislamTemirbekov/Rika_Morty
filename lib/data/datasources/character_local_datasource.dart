import '../../domain/entities/character.dart';

abstract class CharacterLocalDataSource {
  Future<List<Character>> getCharacters();
  Future<void> cacheCharacters(List<Character> characters);
  Future<void> clearCache();
}

