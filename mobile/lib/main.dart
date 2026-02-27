import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/lambda_repository.dart';
import 'services/amplify_service.dart';
import 'services/lambda_service.dart';
import 'viewmodels/home_view_model.dart';
import 'views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final amplifyService = AmplifyService();
  await amplifyService.configure();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Services
        Provider(create: (_) => LambdaService()),

        /// Repositories
        ProxyProvider<LambdaService, LambdaRepository>(
          update: (_, lambdaService, __) => LambdaRepository(lambdaService),
        ),

        /// ViewModels
        ChangeNotifierProxyProvider<LambdaRepository, HomeViewModel>(
          create: (context) => HomeViewModel(context.read<LambdaRepository>()),
          update: (_, lambdaRepository, viewModel) =>
              viewModel ?? HomeViewModel(lambdaRepository),
        ),
      ],
      child: MaterialApp(
        title: 'DataQube',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}
