import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Amplify Lambda Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(vm.message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: vm.isLoading ? null : vm.callLambda,
              child: vm.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Call Lambda'),
            ),
            /// TODO: Add new button for new endpoint
            // ElevatedButton(
            //   onPressed: vm.isLoading ? null : vm.callLambda,
            //   child: vm.isLoading
            //       ? const SizedBox(
            //           height: 20,
            //           width: 20,
            //           child: CircularProgressIndicator(strokeWidth: 2),
            //         )
            //       : const Text('Call Lambda 2'),
            // ),
          ],
        ),
      ),
    );
  }
}
