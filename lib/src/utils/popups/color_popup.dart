import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop<Color>(null);
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop<Color>(currColor);
          },
        ),
      ],
    );
  }
}
