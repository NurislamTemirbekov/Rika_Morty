import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/character_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<SortType>(
                icon: const Icon(Icons.sort),
                onSelected: (SortType type) => provider.setSortType(type),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<SortType>(
                      value: SortType.name,
                      child: Row(
                        children: [
                          Icon(provider.sortType == SortType.name ? Icons.check : Icons.sort_by_alpha),
                          const SizedBox(width: 8),
                          const Text('Sort by Name'),
                          if (provider.sortType == SortType.name)
                            Icon(
                              provider.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem<SortType>(
                      value: SortType.status,
                      child: Row(
                        children: [
                          Icon(provider.sortType == SortType.status ? Icons.check : Icons.favorite),
                          const SizedBox(width: 8),
                          const Text('Sort by Status'),
                          if (provider.sortType == SortType.status)
                            Icon(
                              provider.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem<SortType>(
                      value: SortType.species,
                      child: Row(
                        children: [
                          Icon(provider.sortType == SortType.species ? Icons.check : Icons.science),
                          const SizedBox(width: 8),
                          const Text('Sort by Species'),
                          if (provider.sortType == SortType.species)
                            Icon(
                              provider.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  ];
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add characters to favorites by tapping the star icon',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(provider.favorites[index].id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Remove from favorites?'),
                        content: Text('Are you sure you want to remove ${provider.favorites[index].name} from favorites?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Remove', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  final character = provider.favorites[index];
                  provider.removeFavorite(character.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${character.name} removed from favorites'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => provider.toggleFavorite(character),
                      ),
                    ),
                  );
                },
                child: CharacterCard(character: provider.favorites[index]),
              );
            },
          );
        },
      ),
    );
  }
}
