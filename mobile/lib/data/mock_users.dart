import '../models/user_entity.dart';

const List<Map<String, dynamic>> kMockUsersJson = [
  {
    'id': 1,
    'name': 'Leanne Graham',
    'username': 'Bret',
    'email': 'leanne@example.com',
    'phone': '1-770-736-8031 x56442',
    'website': 'hildegard.org',
    'company': {'name': 'Romaguera-Crona'},
    'address': {'city': 'Gwenborough'},
  },
  {
    'id': 2,
    'name': 'Ervin Howell',
    'username': 'Antonette',
    'email': 'ervin@example.com',
    'phone': '010-692-6593 x09125',
    'website': 'anastasia.net',
    'company': {'name': 'Deckow-Crist'},
    'address': {'city': 'Wisokyburgh'},
  },
  {
    'id': 3,
    'name': 'Clementine Bauch',
    'username': 'Samantha',
    'email': 'clementine@example.com',
    'phone': '1-463-123-4447',
    'website': 'ramiro.info',
    'company': {'name': 'Romaguera-Jacobson'},
    'address': {'city': 'McKenziehaven'},
  },
  {
    'id': 4,
    'name': 'Patricia Lebsack',
    'username': 'Karianne',
    'email': 'patricia@example.com',
    'phone': '493-170-9623 x156',
    'website': 'kale.biz',
    'company': {'name': 'Robel-Corkery'},
    'address': {'city': 'South Elvis'},
  },
  {
    'id': 5,
    'name': 'Chelsey Dietrich',
    'username': 'Kamren',
    'email': 'chelsey@example.com',
    'phone': '(254)954-1289',
    'website': 'demarco.info',
    'company': {'name': 'Keebler LLC'},
    'address': {'city': 'Roscoeview'},
  },
];

List<UserEntity> loadMockUsers() {
  return kMockUsersJson.map(UserEntity.fromJson).toList(growable: false);
}
