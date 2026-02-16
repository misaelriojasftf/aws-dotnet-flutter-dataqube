class AppValidators {
  const AppValidators._();

  static String? minFourChars(String? value, {required String fieldName}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '$fieldName is required';
    }
    if (text.length <= 4) {
      return '$fieldName must be more than 4 chars';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(text)) {
      return 'Enter a valid email';
    }

    return null;
  }
}
