import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../services/storage_service.dart';

enum SortType { name, status, species }

class FavoritesProvider extends ChangeNotifier {
  List<Character> _favorites = [];
  Set<int> _favoriteIds = {};
  SortType _sortType = SortType.name;
  bool _isAscending = true;

  List<Character> get favorites => _getSortedFavorites();
  Set<int> get favoriteIds => _favoriteIds;
  SortType get sortType => _sortType;
  bool get isAscending => _isAscending;

  FavoritesProvider() {
    _init();
  }

  Future<void> _init() async {
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      _favoriteIds = (await StorageService.getFavoriteIds()).toSet();
      final allCharacters = await StorageService.getCharacters();
      _favorites = allCharacters.where((c) => _favoriteIds.contains(c.id)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  bool isFavorite(int characterId) {
    return _favoriteIds.contains(characterId);
  }

  Future<void> toggleFavorite(Character character) async {
    try {
      if (_favoriteIds.contains(character.id)) {
        await StorageService.removeFavorite(character.id);
        _favoriteIds.remove(character.id);
        _favorites.removeWhere((c) => c.id == character.id);
      } else {
        await StorageService.addFavorite(character.id);
        _favoriteIds.add(character.id);
        _favorites.add(character);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> removeFavorite(int characterId) async {
    try {
      await StorageService.removeFavorite(characterId);
      _favoriteIds.remove(characterId);
      _favorites.removeWhere((c) => c.id == characterId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  void setSortType(SortType type) {
    if (_sortType == type) {
      _isAscending = !_isAscending;
    } else {
      _sortType = type;
      _isAscending = true;
    }
    notifyListeners();
  }

  List<Character> _getSortedFavorites() {
    final sorted = List<Character>.from(_favorites);

    switch (_sortType) {
      case SortType.name:
        sorted.sort((a, b) => _isAscending
            ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
            : b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case SortType.status:
        sorted.sort((a, b) => _isAscending
            ? a.status.toLowerCase().compareTo(b.status.toLowerCase())
            : b.status.toLowerCase().compareTo(a.status.toLowerCase()));
        break;
      case SortType.species:
        sorted.sort((a, b) => _isAscending
            ? a.species.toLowerCase().compareTo(b.species.toLowerCase())
            : b.species.toLowerCase().compareTo(a.species.toLowerCase()));
        break;
    }

    return sorted;
  }
}
