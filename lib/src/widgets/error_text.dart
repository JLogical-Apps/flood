import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/popup/export.dart';

/// Text that displays an error message and can retry a failed operation.
class ErrorText extends StatelessWidget {
  /// The text of the error to display.
  final String errorText;

  /// The error to show when clicked. If null, then this isn't clickable.
  final dynamic error;

  const ErrorText(this.errorText, {this.error});

  @override
  Widget build(BuildContext context) {
    return error == null
        ? Text(
            errorText,
            style: TextStyle(color: Colors.red),
          )
        : OutlinedButton(
            child: Text(errorText),
            onPressed: () {
              Popup.message(context, title: 'Error Message', message: error.toString(), okText: 'OK');
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.red),
              overlayColor: MaterialStateProperty.all(Colors.red.withOpacity(0.2)),
            ),
          );
  }
}
