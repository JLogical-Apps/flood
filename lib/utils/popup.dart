import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

class ColorPickerPopup extends StatefulWidget {
  final Color initialColor;

  const ColorPickerPopup({@required this.initialColor});

  @override
  _ColorPickerPopupState createState() => _ColorPickerPopupState();
}

class _ColorPickerPopupState extends State<ColorPickerPopup> {
  Color currColor;

  @override
  void initState() {
    super.initState();

    currColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Color'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: currColor,
          onColorChanged: (color) => setState(() => currColor = color),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop<Color>(null);
          },
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop<Color>(currColor);
          },
        ),
      ],
    );
  }
}
