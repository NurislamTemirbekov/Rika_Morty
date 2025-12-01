import 'package:flutter/foundation.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';

enum LoadingState { initial, loading, loaded, error, loadingMore }

class CharactersProvider extends ChangeNotifier {
  final CharacterRepository repository;

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

  CharactersProvider(this.repository) {
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
      final cached = await repository.getCachedCharacters();
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
      final newCharacters = await repository.getCharacters(_currentPage);

      if (refresh) {
        _characters = newCharacters;
      } else {
        _characters.addAll(newCharacters);
      }

      _hasMore = newCharacters.length == 20;
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
      final newCharacters = await repository.getCharacters(_currentPage);
      _characters.addAll(newCharacters);
      _hasMore = newCharacters.length >= 20;
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

