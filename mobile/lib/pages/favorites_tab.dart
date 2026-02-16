import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Consumer<UsersProvider>(
        builder: (context, usersProvider, _) {
          final favorites = usersProvider.favoriteUsers;

          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final user = favorites[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Text('${user.username} • ${user.email}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      context.read<UsersProvider>().toggleFavorite(user);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
