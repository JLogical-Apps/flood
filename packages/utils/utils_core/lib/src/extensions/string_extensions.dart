

extension StringExtensions on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

  bool get isEmail => RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .allMatches(this)
      .isNotEmpty;

  String? get nullIfBlank => isBlank ? null : this;

  String withIndent(int spaces) {
    return split('\n').map((line) => (' ' * spaces) + line).join('\n');
  }

  String get withoutAnsiEscapeCodes => replaceAll(RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]'), '');
}
