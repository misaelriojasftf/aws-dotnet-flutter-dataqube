import 'package:flutter/foundation.dart';

import '../data/mock_users.dart';
import '../models/user_entity.dart';

class UsersProvider extends ChangeNotifier {
  List<UserEntity> _users = const [];
  String _query = '';
  final Set<int> _favoriteIds = <int>{};

  List<UserEntity> get users => _users;

  String get query => _query;

  List<UserEntity> get filteredUsers {
    final search = _query.trim().toLowerCase();
    if (search.isEmpty) {
      return _users;
    }

    return _users
        .where((user) {
          return user.name.toLowerCase().contains(search) ||
              user.username.toLowerCase().contains(search) ||
              user.email.toLowerCase().contains(search);
        })
        .toList(growable: false);
  }

  List<UserEntity> get favoriteUsers {
    return _users
        .where((user) => _favoriteIds.contains(user.id))
        .toList(growable: false);
  }

  bool isFavorite(int userId) {
    return _favoriteIds.contains(userId);
  }

  Future<void> loadUsers() async {
    // Session 1 keeps this local. A later commit can swap this to HTTP.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _users = loadMockUsers();
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void toggleFavorite(UserEntity user) {
    if (_favoriteIds.contains(user.id)) {
      _favoriteIds.remove(user.id);
    } else {
      _favoriteIds.add(user.id);
    }
    notifyListeners();
  }

  void addUser(UserEntity _) {
    // TODO(exercise): Append the new user to `_users` and call notifyListeners().
    // This method is intentionally left as exercise scaffolding for commit 4.
  }
}
