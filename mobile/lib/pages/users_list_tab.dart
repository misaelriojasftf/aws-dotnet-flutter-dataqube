import 'package:flutter/material.dart';

import '../data/mock_users.dart';
import '../models/user_entity.dart';
import 'account_page.dart';

class UsersListTab extends StatefulWidget {
  const UsersListTab({super.key});

  @override
  State<UsersListTab> createState() => _UsersListTabState();
}

class _UsersListTabState extends State<UsersListTab> {
  final TextEditingController _searchController = TextEditingController();
  List<UserEntity> _users = const [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    // Session 1 uses local mock data only.
    // In a later commit/class we can switch this to an API call and keep
    // the same UserEntity model fields.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!mounted) {
      return;
    }

    setState(() {
      _users = loadMockUsers();
    });
  }

  List<UserEntity> get _filteredUsers {
    if (_query.trim().isEmpty) {
      return _users;
    }

    final q = _query.toLowerCase();
    return _users
        .where((user) {
          return user.name.toLowerCase().contains(q) ||
              user.username.toLowerCase().contains(q) ||
              user.email.toLowerCase().contains(q);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;

    return Scaffold(
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
      body: RefreshIndicator(
        onRefresh: _loadUsers,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search users',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
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
                    trailing: Text(user.city),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
