import 'package:dataqube/features/auth/data/auth_service.dart';
import 'package:dataqube/features/auth/domain/auth_session.dart';
import 'package:dataqube/features/auth/presentation/screens/home_screen.dart';
import 'package:dataqube/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();

  AuthSession? _session;
  String? _error;
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final session = await _authService.loadSession();
      if (!mounted) return;
      setState(() => _session = session);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Failed to restore session: $e');
    } finally {
      if (!mounted) return;
      setState(() => _busy = false);
    }
  }

  Future<void> _login() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final session = await _authService.login();
      if (!mounted) return;
      setState(() => _session = session);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Login failed: $e');
    } finally {
      if (!mounted) return;
      setState(() => _busy = false);
    }
  }

  Future<void> _logout() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await _authService.logout();
      if (!mounted) return;
      setState(() => _session = null);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Logout failed: $e');
    } finally {
      if (!mounted) return;
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_busy) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_session == null) {
      return LoginScreen(
        error: _error,
        onLoginPressed: _login,
      );
    }

    return HomeScreen(
      session: _session!,
      onLogoutPressed: _logout,
      error: _error,
    );
  }
}
