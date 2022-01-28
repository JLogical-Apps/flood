extension StringExtensions on String {
  /// Whether the text is empty or only whitespace.
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

  /// Whether the text represents an email.
  bool get isEmail => RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .allMatches(this)
      .isNotEmpty;

  /// Returns everything after the first instance of [pattern]. If this doesn't contain [pattern], then returns a blank string.
  String allAfter(Pattern pattern) {
    final index = indexOf(pattern);
    if (index == -1) {
      return '';
    }
    return substring(index + 1);
  }

  /// Returns everything before the first instance of [pattern]. If this doesn't contain [pattern], then returns a blank string.
  String allBefore(Pattern pattern) {
    final index = indexOf(pattern);
    if (index == -1) {
      return '';
    }

    return substring(0, index);
  }

  String? get nullIfBlank {
    return isBlank ? null : this;
  }
}
