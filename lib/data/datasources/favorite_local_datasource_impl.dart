import 'package:hive/hive.dart';
import 'favorite_local_datasource.dart';

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  static const String boxName = 'favorites';

  Future<Box<int>> get _box async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<int>(boxName);
    }
    return Hive.box<int>(boxName);
  }

  @override
  Future<List<int>> getFavoriteIds() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<void> addFavorite(int id) async {
    final box = await _box;
    await box.put(id, id);
  }

  @override
  Future<void> removeFavorite(int id) async {
    final box = await _box;
    await box.delete(id);
  }

  @override
  Future<bool> isFavorite(int id) async {
    final box = await _box;
    return box.containsKey(id);
  }
}

