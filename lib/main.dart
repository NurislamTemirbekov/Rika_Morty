import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'data/repositories/character_repository_impl.dart';
import 'data/repositories/favorite_repository_impl.dart';
import 'data/datasources/character_remote_datasource_impl.dart';
import 'data/datasources/character_local_datasource_impl.dart';
import 'data/datasources/favorite_local_datasource_impl.dart';
import 'core/services/network_info_impl.dart';
import 'data/models/character_model.dart';
import 'presentation/providers/characters_provider.dart';
import 'presentation/providers/favorites_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CharacterModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    final connectivity = Connectivity();

    final networkInfo = NetworkInfoImpl(connectivity);
    final remoteDataSource = CharacterRemoteDataSourceImpl(httpClient);
    final localDataSource = CharacterLocalDataSourceImpl();
    final favoriteDataSource = FavoriteLocalDataSourceImpl();

    final characterRepository = CharacterRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );

    final favoriteRepository = FavoriteRepositoryImpl(favoriteDataSource);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => CharactersProvider(characterRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(
            favoriteRepository: favoriteRepository,
            characterRepository: characterRepository,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Rick and Morty',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
