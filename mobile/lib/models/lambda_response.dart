class LambdaResponse {
  final String message;

  const LambdaResponse({required this.message});

  factory LambdaResponse.fromRaw(String rawBody) {
    final trimmed = rawBody.trim();
    return LambdaResponse(
      message: trimmed.isEmpty ? 'Empty response from Lambda' : trimmed,
    );
  }
}
