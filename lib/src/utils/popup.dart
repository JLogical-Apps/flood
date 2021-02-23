import 'package:flutter/material.dart';

import 'popups/color_popup.dart';
import 'popups/input_popup.dart';

/// Helper class that shows popups.
class Popup {
  /// Shows a dialog with a message.
  static Future<void> message(BuildContext context, {@required String title, @required String message, String okText: 'OK'}) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (bc) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              OutlinedButton(
                child: new Text(okText),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  /// Shows a dialog that asks a yes/no question. Cancelling the dialog counts as a no.
  static Future<bool> yesNo(BuildContext context, {@required String title, @required String message, String noMsg: "NEVERMIND", String yesMsg: "OK"}) async {
    var output = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (bc) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(noMsg),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              OutlinedButton(
                child: new Text(yesMsg),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
    return output == null ? false : output;
  }

  /// Shows a dialog that asks for a text input.
  /// Returns null if the dialog was cancelled.
  /// Returns a string if input was submitted. Empty text if no input was added, but still submitted.
  static Future<String> input(
    BuildContext context, {
    @required String title,
    @required String message,
    @required String label,
    String initialText: '',
    String cancelMsg: 'NEVERMIND',
    String submitMsg: 'OK',
    bool canBeEmpty: false,
  }) async {
    var output = await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (bc) {
          return InputPopup(
            title: title,
            message: message,
            label: label,
            cancelMsg: cancelMsg,
            submitMsg: submitMsg,
            canBeEmpty: canBeEmpty,
            initialText: initialText,
          );
        });
    return output;
  }

  /// Show a popup so that the user can change the color.
  static Future<Color> chooseColor(BuildContext context, {Color initialColor}) async {
    var output = await showDialog<Color>(
        context: context,
        barrierDismissible: true,
        builder: (bc) {
          return ColorPickerPopup(initialColor: initialColor);
        });
    return output == null ? false : output;
  }
}