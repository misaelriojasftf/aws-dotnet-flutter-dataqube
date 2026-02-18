import '../models/user_entity.dart';
import '../storage/storage_service.dart';
import 'users_api_service.dart';

abstract class UsersRepository {
  Future<List<UserEntity>> getUsers();
}

class ApiUsersRepository implements UsersRepository {
  ApiUsersRepository({
    required UsersApiService apiService,
    required StorageService<UserEntity, int> storage,
  }) : _apiService = apiService,
       _storage = storage;

  final UsersApiService _apiService;
  final StorageService<UserEntity, int> _storage;

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      final users = await _apiService.getUsers();
      await _storage.writeAll(users);
      return users;
    } catch (_) {
      return _getCachedUsers();
    }
  }

  Future<List<UserEntity>> _getCachedUsers() async {
    return _storage.readAll();
  }
}
