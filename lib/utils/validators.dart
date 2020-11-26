import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Holds some useful validation functions.
class Validators {
  /// Validates the given [text] by the given [minLength].
  static String minLength(String text, {@required int minLength, @required String onEmpty, @required String onShortLength}) {
    text = text.trim();
    if (text.isEmpty) return onEmpty;
    if (text.length < minLength) return onShortLength;

    return null;
  }

  /// Validates the given [text] by it being not empty.
  static String notEmpty(String text, {@required String onEmpty}) {
    text = text.trim();
    if (text.isEmpty) return onEmpty;

    return null;
  }

  /// Validates the given [text] as an email.
  static String email(String text, {@required String onEmpty, @required String onInvalid}) {
    text = text.trim();
    if (text.isEmpty) return onEmpty;

    var regex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (regex.allMatches(text).isEmpty) return onInvalid;

    return null;
  }

  /// Validates the given [text] as a password.
  static String password(String text, {@required String onEmpty, @required String onShortLength}) {
    if (text.isEmpty) return onEmpty;
    if (text.length < 6) return onShortLength;
    return null;
  }

  /// Validates for a confirm password box. Ensures the password and confirm password are the same.
  static String confirmPassword(String text, {@required String passwordText, @required String onEmpty, @required String onNotSame}) {
    if (text.isEmpty) return onEmpty;
    if (text != passwordText) return onNotSame;
    return null;
  }

  /// Displays an async error message if [error] is not empty.
  static String asyncError(String error) {
    if (error == null) return null;
    return error.isEmpty ? null : error;
  }

  /// Handles multiple validators.
  static String multi(String text, {@required List<String Function(String)> validators}) {
    for (var validator in validators) {
      String err = validator(text);
      if (err != null) return err;
    }
    return null;
  }
}
