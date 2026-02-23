import 'dart:convert';

class JwtUtils {
  const JwtUtils._();

  static String? extractEmail(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length < 2) return null;

      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final map = jsonDecode(payload) as Map<String, dynamic>;
      final email = map['email'];
      return email is String ? email : null;
    } catch (_) {
      return null;
    }
  }
}
