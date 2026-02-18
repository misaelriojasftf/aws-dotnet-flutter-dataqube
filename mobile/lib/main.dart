import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'data/users_api_service.dart';
import 'data/users_repository.dart';
import 'models/user_entity_adapter.dart';
import 'pages/home_page.dart';
import 'providers/users_provider.dart';
import 'storage/hive_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!Hive.isAdapterRegistered(UserEntityAdapter.kTypeId)) {
    Hive.registerAdapter(UserEntityAdapter());
  }

  final storage = HiveStorage();
  await storage.init();

  final usersProvider = UsersProvider(
    usersRepository: ApiUsersRepository(
      apiService: UsersApiService(),
      storage: storage,
    ),
  )..loadUsers();

  runApp(DataQubeApp(usersProvider: usersProvider));
}

class DataQubeApp extends StatelessWidget {
  const DataQubeApp({super.key, required this.usersProvider});

  final UsersProvider usersProvider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersProvider>.value(
      value: usersProvider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DataQube Users',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomePage(),
      ),
    );
  }
}
