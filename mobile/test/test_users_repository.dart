import 'package:dataqube/data/users_repository.dart';
import 'package:dataqube/models/user_entity.dart';

class TestUsersRepository implements UsersRepository {
  TestUsersRepository({required List<UserEntity> users}) : _users = users;

  final List<UserEntity> _users;

  @override
  Future<List<UserEntity>> getUsers() async {
    return List<UserEntity>.from(_users);
  }
}

const kTestUsers = <UserEntity>[
  UserEntity(
    id: 1,
    name: 'Leanne Graham',
    username: 'Bret',
    email: 'leanne@example.com',
    phone: '1-770-736-8031 x56442',
    website: 'hildegard.org',
    companyName: 'Romaguera-Crona',
    city: 'Gwenborough',
  ),
  UserEntity(
    id: 2,
    name: 'Ervin Howell',
    username: 'Antonette',
    email: 'ervin@example.com',
    phone: '010-692-6593 x09125',
    website: 'anastasia.net',
    companyName: 'Deckow-Crist',
    city: 'Wisokyburgh',
  ),
];
