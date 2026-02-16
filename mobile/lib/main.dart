import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'providers/users_provider.dart';

void main() {
  runApp(const DataQubeApp());
}

class DataQubeApp extends StatelessWidget {
  const DataQubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersProvider>(
      create: (_) => UsersProvider()..loadUsers(),
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
