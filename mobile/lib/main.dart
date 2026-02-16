import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const DataQubeApp());
}

class DataQubeApp extends StatelessWidget {
  const DataQubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DataQube Users',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}
