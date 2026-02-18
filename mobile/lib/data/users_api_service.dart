import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_entity.dart';

class UsersApiService {
  UsersApiService({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _usersEndpoint =
      Uri.parse('https://jsonplaceholder.typicode.com/users');

  final http.Client _client;

  Future<List<UserEntity>> getUsers() async {
    final response = await _client.get(_usersEndpoint);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch users: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Invalid users payload');
    }

    return decoded
        .whereType<Map>()
        .map((raw) => Map<String, dynamic>.from(raw))
        .map(UserEntity.fromJson)
        .toList(growable: false);
  }
}
