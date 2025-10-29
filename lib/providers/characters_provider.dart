import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum LoadingState { initial, loading, loaded, error, loadingMore }

class CharactersProvider extends ChangeNotifier {
  List<Character> _characters = [];
  LoadingState _state = LoadingState.initial;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  List<Character> get characters => _characters;
  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoading => _state == LoadingState.loading;
  bool get isLoadingMore => _state == LoadingState.loadingMore;

  CharactersProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadFromCache();
    if (_characters.isEmpty) {
      await loadCharacters();
    }
  }

  Future<void> _loadFromCache() async {
    try {
      final cached = await StorageService.getCharacters();
      if (cached.isNotEmpty) {
        _characters = cached;
        _state = LoadingState.loaded;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading from cache: $e');
    }
  }

  Future<void> loadCharacters({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _characters.clear();
      _hasMore = true;
    }

    _state = LoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.getCharacters(_currentPage);
      final newCharacters = result['characters'] as List<Character>;

      if (refresh) {
        _characters = newCharacters;
        await StorageService.clearCharacters();
      } else {
        _characters.addAll(newCharacters);
      }

      await StorageService.saveCharacters(newCharacters);
      _hasMore = result['hasNext'] as bool;
      _state = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = LoadingState.error;

      if (_characters.isEmpty) {
        await _loadFromCache();
      }
    }

    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _state == LoadingState.loadingMore) return;

    _state = LoadingState.loadingMore;
    notifyListeners();

    _currentPage++;

    try {
      final result = await ApiService.getCharacters(_currentPage);
      final newCharacters = result['characters'] as List<Character>;

      _characters.addAll(newCharacters);
      await StorageService.saveCharacters(newCharacters);
      _hasMore = result['hasNext'] as bool;
      _state = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _currentPage--;
      _state = LoadingState.error;
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    await loadCharacters(refresh: true);
  }
}
