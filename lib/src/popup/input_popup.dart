import 'package:flutter/material.dart';

import '../widgets/export.dart';

class InputPopup extends StatefulWidget {
  final String title;
  final String message;
  final String label;
  final String initialText;
  final String cancelMsg;
  final String submitMsg;
  final bool canBeEmpty;

  InputPopup({
    required this.title,
    required this.message,
    required this.label,
    required this.initialText,
    required this.cancelMsg,
    required this.submitMsg,
    required this.canBeEmpty,
  });

  @override
  _InputPopupState createState() => _InputPopupState();
}

class _InputPopupState extends State<InputPopup> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.message),
            InputField(
              controller: _controller,
              label: widget.label,
              initialText: widget.initialText,
              onChange: (s) => setState(() {}),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(widget.cancelMsg),
          onPressed: () {
            Navigator.of(context).pop<String>(null);
          },
        ),
        OutlinedButton(
          child: new Text(widget.submitMsg),
          onPressed: _controller.text.isNotEmpty || widget.canBeEmpty
              ? () {
                  Navigator.of(context).pop<String>(_controller.text);
                }
              : null,
        ),
      ],
    );
  }
}
