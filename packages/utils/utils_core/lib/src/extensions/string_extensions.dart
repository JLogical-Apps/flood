extension StringExtensions on String {
  /// Whether the text is empty or only whitespace.
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

  /// Whether the text represents an email.
  bool get isEmail => RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .allMatches(this)
      .isNotEmpty;

  String? get nullIfBlank => isBlank ? null : this;

  String withIndent(int spaces) {
    return split('\n').map((line) => (' ' * spaces) + line).join('\n');
  }
}
