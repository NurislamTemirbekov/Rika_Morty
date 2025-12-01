import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_datasource.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource localDataSource;

  FavoriteRepositoryImpl(this.localDataSource);

  @override
  Future<List<int>> getFavoriteIds() async {
    return await localDataSource.getFavoriteIds();
  }

  @override
  Future<void> addFavorite(int id) async {
    await localDataSource.addFavorite(id);
  }

  @override
  Future<void> removeFavorite(int id) async {
    await localDataSource.removeFavorite(id);
  }

  @override
  Future<bool> isFavorite(int id) async {
    return await localDataSource.isFavorite(id);
  }
}

