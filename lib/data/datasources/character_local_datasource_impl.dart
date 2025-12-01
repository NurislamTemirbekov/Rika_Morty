import 'package:hive/hive.dart';
import '../../domain/entities/character.dart';
import '../models/character_model.dart';
import 'character_local_datasource.dart';

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  static const String boxName = 'characters';

  Future<Box<CharacterModel>> get _box async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<CharacterModel>(boxName);
    }
    return Hive.box<CharacterModel>(boxName);
  }

  @override
  Future<List<Character>> getCharacters() async {
    final box = await _box;
    return box.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> cacheCharacters(List<Character> characters) async {
    final box = await _box;
    final models = characters.map((char) => CharacterModel.fromEntity(char)).toList();
    await box.clear();
    for (var model in models) {
      await box.put(model.id, model);
    }
  }

  @override
  Future<void> clearCache() async {
    final box = await _box;
    await box.clear();
  }
}

