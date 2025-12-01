abstract class FavoriteRepository {
  Future<List<int>> getFavoriteIds();
  Future<void> addFavorite(int id);
  Future<void> removeFavorite(int id);
  Future<bool> isFavorite(int id);
}

