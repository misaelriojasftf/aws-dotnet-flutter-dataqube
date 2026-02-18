import 'package:flutter/foundation.dart';

import '../data/users_repository.dart';
import '../models/user_entity.dart';

class UsersProvider extends ChangeNotifier {
  UsersProvider({required UsersRepository usersRepository})
    : _usersRepository = usersRepository;

  final UsersRepository _usersRepository;
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
    _users = await _usersRepository.getUsers();
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

  void addUser(UserEntity user) {
    _users = [..._users, user];
    notifyListeners();
  }
}
