import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';
import 'account_page.dart';

class UsersListTab extends StatelessWidget {
  const UsersListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add user',
        onPressed: () {
          // TODO(exercise): Open add user sheet / dialog / screen.
        },
        child: const Icon(Icons.person_add_alt_1),
      ),
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'Account',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AccountPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<UsersProvider>(
        builder: (context, usersProvider, _) {
          final users = usersProvider.filteredUsers;

          return RefreshIndicator(
            onRefresh: usersProvider.loadUsers,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search users',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: usersProvider.setQuery,
                ),
                const SizedBox(height: 12),
                if (users.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text('No users found')),
                  )
                else
                  ...users.map(
                    (user) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: Text('${user.username} • ${user.email}'),
                        trailing: IconButton(
                          key: ValueKey('toggle-favorite-${user.id}'),
                          tooltip: 'Toggle favorite',
                          icon: Icon(
                            usersProvider.isFavorite(user.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: usersProvider.isFavorite(user.id)
                                ? Colors.red
                                : null,
                          ),
                          onPressed: () {
                            context.read<UsersProvider>().toggleFavorite(user);
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}