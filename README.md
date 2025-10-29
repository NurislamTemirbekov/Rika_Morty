# Rick and Morty Characters

Flutter app to browse characters from Rick and Morty series using public API.

## Features

- Browse all characters with pagination
- Add/remove favorites
- Sort favorites by name, status, or species
- Offline mode with caching
- Dark/light theme toggle
- Smooth animations

## Tech Stack

- **State Management**: Provider
- **Database**: Hive (NoSQL)
- **API**: REST (Rick and Morty API)
- **Theme Storage**: SharedPreferences
- **Image Caching**: cached_network_image

## Dependencies

```yaml
provider: ^6.1.2
hive: ^2.2.3
hive_flutter: ^1.1.0
http: ^1.2.0
shared_preferences: ^2.3.5
cached_network_image: ^3.4.1
equatable: ^2.0.5
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

## Project Structure

```
lib/
├── models/             # Data models
├── providers/          # State management
├── screens/           # UI screens
├── services/          # API & Storage
├── utils/             # Themes & helpers
├── widgets/           # Reusable widgets
└── main.dart
```

## Features Details

### Home Screen
- Character cards with image and info
- Infinite scroll with pagination
- Pull-to-refresh
- Add to favorites with animation
- Works offline

### Favorites Screen
- List of favorite characters
- Sort by name/status/species
- Swipe to delete with confirmation
- Undo delete option

### Theme Toggle
- Light/dark mode
- Persistent across app restarts
- FAB button for quick toggle

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

## License

MIT
