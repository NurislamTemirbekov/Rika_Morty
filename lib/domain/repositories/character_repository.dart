import '../entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharacters(int page);
  Future<List<Character>> getCachedCharacters();
  Future<void> cacheCharacters(List<Character> characters);
  Future<void> clearCache();
}

