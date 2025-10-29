import 'package:hive/hive.dart';
import '../models/character.dart';

class StorageService {
  static const String charactersBox = 'characters';
  static const String favoritesBox = 'favorites';

  static Future<void> init() async {
    Hive.registerAdapter(CharacterAdapter());
  }

  static Future<void> saveCharacters(List<Character> characters) async {
    final box = await Hive.openBox<Character>(charactersBox);
    for (var character in characters) {
      await box.put(character.id, character);
    }
  }

  static Future<List<Character>> getCharacters() async {
    final box = await Hive.openBox<Character>(charactersBox);
    return box.values.toList();
  }

  static Future<void> clearCharacters() async {
    final box = await Hive.openBox<Character>(charactersBox);
    await box.clear();
  }

  static Future<List<int>> getFavoriteIds() async {
    final box = await Hive.openBox<int>(favoritesBox);
    return box.values.toList();
  }

  static Future<void> addFavorite(int id) async {
    final box = await Hive.openBox<int>(favoritesBox);
    await box.put(id, id);
  }

  static Future<void> removeFavorite(int id) async {
    final box = await Hive.openBox<int>(favoritesBox);
    await box.delete(id);
  }

  static Future<bool> isFavorite(int id) async {
    final box = await Hive.openBox<int>(favoritesBox);
    return box.containsKey(id);
  }
}

