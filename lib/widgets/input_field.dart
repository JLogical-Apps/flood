import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text field with additional functionality.
class InputField extends StatefulWidget {
  /// The controller to use with the field. If [null], a controller is created.
  final TextEditingController controller;

  /// The label of the input field.
  final String label;

  /// The initial text of the input field.
  final String initialText;

  /// The max length of the input field. If [0], no max length.
  /// The max length will be visible to the user when they are 10 characters away from it.
  final int maxLength;

  /// THe max lines to show. Defaults to [1].
  final int maxLines;

  /// Whether to obscure the text for passwords.
  final bool obscureText;

  /// Whether the input field is enabled.
  final bool enabled;

  /// Whether the input field is readonly.
  final bool readonly;

  /// The line color of the input field.
  final Color lineColor;

  /// The keyboard type of the text field.
  final TextInputType keyboardType;

  /// Function to call when the text field is submitted.
  final void Function(String text) onSubmit;

  /// Function to call when the text changes.
  final void Function(String text) onChange;

  /// Function to call to validate the text in the text field.
  final String Function(String text) validator;

  /// Error text to show.
  final String errorText;

  const InputField({
    Key key,
    this.controller,
    this.label,
    this.initialText,
    this.maxLength: 0,
    this.maxLines: 1,
    this.obscureText: false,
    this.readonly: false,
    this.enabled: true,
    this.lineColor: Colors.black,
    this.keyboardType,
    this.onSubmit,
    this.onChange,
    this.validator,
    this.errorText,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.initialText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        enabled: widget.enabled,
        inputFormatters: [],
        readOnly: widget.readonly,
        controller: controller,
        maxLength: widget.maxLength == 0 || widget.controller.text.length < widget.maxLength - 10 ? null : widget.maxLength,
        cursorColor: widget.lineColor,
        obscureText: widget.obscureText,
        style: TextStyle(
          color: widget.lineColor,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: widget.lineColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          errorText: widget.errorText,
        ),
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        onFieldSubmitted: widget.onSubmit,
        onChanged: (s) {
          setState(() {});
          widget.onChange(s);
        },
        validator: widget.validator,
      ),
    );
  }
}
