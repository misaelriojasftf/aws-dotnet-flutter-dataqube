import 'package:dataqube/core/utils/jwt_utils.dart';
import 'package:dataqube/features/auth/domain/auth_session.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.session,
    required this.onLogoutPressed,
    this.error,
    super.key,
  });

  final AuthSession session;
  final VoidCallback onLogoutPressed;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final email = JwtUtils.extractEmail(session.idToken);
    final tokenPreview = session.accessToken.length > 24
        ? '${session.accessToken.substring(0, 24)}...'
        : session.accessToken;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logged in',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (email != null) Text('Email: $email'),
            Text('Access token: $tokenPreview'),
            if (session.expiresAt != null)
              Text('Expires at: ${session.expiresAt!.toLocal()}'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onLogoutPressed,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
            if (error != null) ...[
              const SizedBox(height: 16),
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
