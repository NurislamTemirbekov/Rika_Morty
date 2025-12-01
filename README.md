# Rick and Morty Characters

Flutter app to browse characters from Rick and Morty series using public API. Built with Clean Architecture principles and SOLID design patterns.

## Features

- Browse all characters with pagination
- Add/remove favorites
- Sort favorites by name, status, or species
- Offline mode with caching (Offline-First strategy)
- Dark/light theme toggle
- Smooth animations
- Network connectivity check

## Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── domain/              # Business logic layer
│   ├── entities/        # Pure business models
│   └── repositories/    # Repository interfaces (contracts)
│
├── data/                # Data layer
│   ├── datasources/     # Remote & Local data sources
│   ├── models/          # Data models (with Hive annotations)
│   └── repositories/    # Repository implementations
│
├── core/                # Core utilities
│   └── services/        # Network info, error handling
│
└── presentation/        # UI layer
    ├── providers/       # State management (Provider)
    ├── screens/         # App screens
    ├── widgets/         # Reusable widgets
    └── utils/           # Theme configuration
```

### Architecture Benefits

- **Dependency Inversion**: Providers depend on repository interfaces, not implementations
- **Testability**: Easy to mock dependencies for unit testing
- **Maintainability**: Clear separation of concerns
- **Scalability**: Easy to add new features
- **Offline-First**: Automatic fallback to cached data when offline

## Tech Stack

- **State Management**: Provider (ChangeNotifier)
- **Database**: Hive (NoSQL, fast local storage)
- **API**: REST (http package)
- **Network Check**: connectivity_plus
- **Theme Storage**: SharedPreferences
- **Image Caching**: cached_network_image

## Dependencies

```yaml
provider: ^6.1.2              # State management
hive: ^2.2.3                  # NoSQL database
hive_flutter: ^1.1.0          # Hive for Flutter
http: ^1.2.0                  # REST API client
connectivity_plus: ^6.1.5     # Network connectivity check
shared_preferences: ^2.3.5   # Theme storage
cached_network_image: ^3.4.1 # Image caching
equatable: ^2.0.5            # Value equality
```

## Installation

1. Clone repository:
```bash
git clone <repository-url>
cd rika_morti
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run app:
```bash
flutter run
```

## Project Structure Details

### Domain Layer
- **Entities**: Pure business models without framework dependencies
- **Repositories**: Interfaces defining data contracts

### Data Layer
- **DataSources**: 
  - `CharacterRemoteDataSource` - API calls
  - `CharacterLocalDataSource` - Hive storage
  - `FavoriteLocalDataSource` - Favorites storage
- **Models**: Data models with Hive annotations for serialization
- **Repositories**: Implementations of domain repository interfaces

### Core Layer
- **NetworkInfo**: Service to check internet connectivity
- Handles offline/online state detection

### Presentation Layer
- **Providers**: State management using Provider pattern
- **Screens**: UI screens (Home, Favorites, Main)
- **Widgets**: Reusable UI components
- **Utils**: Theme configuration

## Features Details

### Home Screen
- Character cards with image and info
- Infinite scroll with pagination
- Pull-to-refresh
- Add to favorites with animation
- Works offline (loads from cache if no internet)

### Favorites Screen
- List of favorite characters
- Sort by name/status/species (ascending/descending)
- Swipe to delete with confirmation
- Undo delete option

### Theme Toggle
- Light/dark mode
- Persistent across app restarts
- FAB button for quick toggle

### Offline Support
- Automatic caching of characters
- Works without internet connection
- Smart fallback: tries API first, falls back to cache on error

## API

Uses [Rick and Morty REST API](https://rickandmortyapi.com/api)

Example endpoint:
```
GET https://rickandmortyapi.com/api/character?page=1
```

## Database

Hive boxes:
- `characters` - cached character data
- `favorites` - favorite character IDs

## Requirements

- Flutter SDK: 3.9.2+
- Dart SDK: 3.9.2+

## Development

Run with hot reload:
```bash
flutter run
```

Check code:
```bash
flutter analyze
```

Run tests:
```bash
flutter test
```

Generate code (Hive adapters):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Design Patterns

- **Clean Architecture**: Separation into layers
- **Repository Pattern**: Abstraction over data sources
- **Dependency Injection**: Manual DI in main.dart
- **Provider Pattern**: State management
- **Offline-First**: Cache-first strategy

## SOLID Principles

- **S**ingle Responsibility: Each class has one reason to change
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Interfaces can be substituted
- **I**nterface Segregation: Small, focused interfaces
- **D**ependency Inversion: Depend on abstractions, not concretions

## License

MIT
