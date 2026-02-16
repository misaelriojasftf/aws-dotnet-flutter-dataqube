import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_test/flutter_test.dart';

import 'package:dataqube/models/user_entity.dart';
import 'package:dataqube/providers/users_provider.dart';


void main() {
  test('addUser appends user and notifies filtered list', () async {
    final provider = UsersProvider();

    debugPrint('🚀 Starting test: addUser');

    await provider.loadUsers();
    debugPrint('✅ Users loaded: ${provider.users.length} users');

    final initialLength = provider.users.length;
    debugPrint('📊 Initial users length: $initialLength');

    const newUser = UserEntity(
      id: 999,
      name: 'Ana Torres',
      username: 'anita',
      email: 'ana@example.com',
      phone: '',
      website: '',
      companyName: '',
      city: 'Madrid',
    );

    debugPrint('➕ Adding user: ${newUser.name} (${newUser.email})');

    provider.addUser(newUser);

    debugPrint('📊 New users length: ${provider.users.length}');
    debugPrint('👤 Last user in list: ${provider.users.last.name}');

    final existsInFiltered = provider.filteredUsers
        .any((user) => user.email == 'ana@example.com');

    debugPrint('🔍 Exists in filteredUsers: $existsInFiltered');
    debugPrint('📋 Filtered users count: ${provider.filteredUsers.length}');

    expect(provider.users.length, initialLength + 1);
    expect(provider.users.last.name, 'Ana Torres');
    expect(existsInFiltered, isTrue);

    debugPrint('✅ Test passed: addUser works correctly\n');
  });
}