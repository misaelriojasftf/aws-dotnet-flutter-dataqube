import 'package:dataqube/core/cognito_config.dart';
import 'package:dataqube/features/auth/domain/auth_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

abstract class AuthService {
  Future<AuthSession?> loadSession();
  Future<AuthSession> login();
  Future<void> logout();
  Future<void> clearLocalSession();
}

class CognitoAuthService implements AuthService {
  CognitoAuthService();

  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static const _idTokenKey = 'id_token';
  static const _expiresAtKey = 'expires_at_iso';

  @override
  Future<AuthSession?> loadSession() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    final idToken = await _storage.read(key: _idTokenKey);
    final expiresAtIso = await _storage.read(key: _expiresAtKey);
    if (accessToken == null || idToken == null) return null;

    final expiresAt =
        expiresAtIso == null ? null : DateTime.tryParse(expiresAtIso);
    final session = AuthSession(
      accessToken: accessToken,
      idToken: idToken,
      expiresAt: expiresAt,
    );

    if (session.isExpired) {
      await clearLocalSession();
      return null;
    }

    return session;
  }

  @override
  Future<AuthSession> login() async {
    _validateConfig();

    final loginUrl = _buildLoginUrl();
    final callbackResult = await FlutterWebAuth2.authenticate(
      url: loginUrl,
      callbackUrlScheme: CognitoConfig.redirectScheme,
    );

    final session = _sessionFromCallback(callbackResult);
    await _storage.write(key: _accessTokenKey, value: session.accessToken);
    await _storage.write(key: _idTokenKey, value: session.idToken);
    await _storage.write(
      key: _expiresAtKey,
      value: session.expiresAt?.toIso8601String(),
    );

    return session;
  }

  @override
  Future<void> logout() async {
    try {
      _validateConfig();
      final logoutUrl = _buildLogoutUrl();

      await FlutterWebAuth2.authenticate(
        url: logoutUrl,
        callbackUrlScheme: CognitoConfig.redirectScheme,
      );
    } catch (_) {
      // If Hosted UI logout fails, still clear local session.
    } finally {
      await clearLocalSession();
    }
  }

  @override
  Future<void> clearLocalSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _idTokenKey);
    await _storage.delete(key: _expiresAtKey);
  }

  void _validateConfig() {
    final isClientSet = CognitoConfig.appClientId != 'YOUR_APP_CLIENT_ID';
    final isDomainSet = CognitoConfig.hostedUiDomain !=
        'YOUR_DOMAIN.auth.us-east-2.amazoncognito.com';

    if (!isClientSet || !isDomainSet) {
      throw StateError(
        'Set appClientId and hostedUiDomain in CognitoConfig before login.',
      );
    }
  }

  String _buildLoginUrl() {
    return Uri.https(CognitoConfig.hostedUiDomain, '/login', {
      'client_id': CognitoConfig.appClientId,
      'response_type': 'token',
      'scope': 'openid email phone',
      'redirect_uri': CognitoConfig.redirectUri,
    }).toString();
  }

  String _buildLogoutUrl() {
    return Uri.https(CognitoConfig.hostedUiDomain, '/logout', {
      'client_id': CognitoConfig.appClientId,
      'logout_uri': CognitoConfig.redirectUri,
    }).toString();
  }

  AuthSession _sessionFromCallback(String callbackResult) {
    final callbackUri = Uri.parse(callbackResult);
    final params = Uri.splitQueryString(callbackUri.fragment);

    final accessToken = params['access_token'];
    final idToken = params['id_token'];
    if (accessToken == null || idToken == null) {
      throw StateError('Login succeeded but tokens were not returned.');
    }

    final expiresInSeconds = int.tryParse(params['expires_in'] ?? '');
    final expiresAt = expiresInSeconds == null
        ? null
        : DateTime.now().add(Duration(seconds: expiresInSeconds));

    return AuthSession(
      accessToken: accessToken,
      idToken: idToken,
      expiresAt: expiresAt,
    );
  }
}
