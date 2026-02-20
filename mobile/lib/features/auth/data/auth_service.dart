import 'package:dataqube/core/config/cognito_config.dart';
import 'package:dataqube/features/auth/domain/auth_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class AuthService {
  AuthService();

  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static const _idTokenKey = 'id_token';
  static const _expiresAtKey = 'expires_at_iso';

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

  Future<AuthSession> login() async {
    _validateConfig();

    final loginUrl = Uri.https(CognitoConfig.hostedUiDomain, '/login', {
      'client_id': CognitoConfig.appClientId,
      'response_type': 'token',
      'scope': 'openid email profile',
      'redirect_uri': CognitoConfig.redirectUri,
    }).toString();

    final callbackResult = await FlutterWebAuth2.authenticate(
      url: loginUrl,
      callbackUrlScheme: CognitoConfig.redirectScheme,
    );

    final callbackUri = Uri.parse(callbackResult);
    final params = Uri.splitQueryString(callbackUri.fragment);
    final accessToken = params['access_token'];
    final idToken = params['id_token'];
    final expiresInRaw = params['expires_in'];

    if (accessToken == null || idToken == null) {
      throw StateError('Login succeeded but tokens were not returned.');
    }

    final expiresInSeconds = int.tryParse(expiresInRaw ?? '');
    final expiresAt = expiresInSeconds == null
        ? null
        : DateTime.now().add(Duration(seconds: expiresInSeconds));

    final session = AuthSession(
      accessToken: accessToken,
      idToken: idToken,
      expiresAt: expiresAt,
    );

    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _idTokenKey, value: idToken);
    await _storage.write(
        key: _expiresAtKey, value: expiresAt?.toIso8601String());

    return session;
  }

  Future<void> logout() async {
    try {
      _validateConfig();
      final logoutUrl = Uri.https(CognitoConfig.hostedUiDomain, '/logout', {
        'client_id': CognitoConfig.appClientId,
        'logout_uri': CognitoConfig.redirectUri,
      }).toString();

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
}
