import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../../core/services/network_info.dart';
import '../datasources/character_local_datasource.dart';
import '../datasources/character_remote_datasource.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Character>> getCharacters(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getCharacters(page);
        if (page == 1) {
          await localDataSource.clearCache();
        }
        await localDataSource.cacheCharacters(remoteData);
        return remoteData;
      } catch (e) {
        if (page == 1) {
          final cachedData = await localDataSource.getCharacters();
          if (cachedData.isNotEmpty) {
            return cachedData;
          }
        }
        rethrow;
      }
    } else {
      return await localDataSource.getCharacters();
    }
  }

  @override
  Future<List<Character>> getCachedCharacters() async {
    return await localDataSource.getCharacters();
  }

  @override
  Future<void> cacheCharacters(List<Character> characters) async {
    await localDataSource.cacheCharacters(characters);
  }

  @override
  Future<void> clearCache() async {
    await localDataSource.clearCache();
  }
}

