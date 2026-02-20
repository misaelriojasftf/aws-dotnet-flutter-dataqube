class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.idToken,
    this.expiresAt,
  });

  final String accessToken;
  final String idToken;
  final DateTime? expiresAt;

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
