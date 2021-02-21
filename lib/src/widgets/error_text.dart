import 'package:flutter/material.dart';

/// Text that displays an error message and can retry a failed operation.
class ErrorText extends StatelessWidget {
  /// The text of the error to display.
  final String errorText;

  const ErrorText({@required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      style: TextStyle(color: Colors.red),
    );
  }
}
