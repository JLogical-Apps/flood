import 'package:flutter/material.dart';

/// Text field with additional functionality.
class InputField extends StatefulWidget {
  /// The controller to use with the field. If [null], a controller is created.
  final TextEditingController? controller;

  /// The label of the input field.
  final String? label;

  /// The initial text of the input field.
  final String initialText;

  /// The hint text to show if no text has been inputted yet.
  final String? hintText;

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

  /// The line color of the input field. If null, uses a default theme.
  final Color? lineColor;

  /// The keyboard type of the text field.
  final TextInputType keyboardType;

  /// Function to call when the text field is submitted.
  final void Function(String text)? onSubmit;

  /// Function to call when the text changes.
  final void Function(String text)? onChange;

  /// Function to call when the field is tapped on.
  final void Function()? onTap;

  /// Function to call to validate the text in the text field.
  final String? Function(String text)? validator;

  /// Error text to show.
  final String? errorText;

  const InputField({
    Key? key,
    this.controller,
    this.label,
    this.initialText = '',
    this.hintText,
    this.maxLength: 0,
    this.maxLines: 1,
    this.obscureText: false,
    this.readonly: false,
    this.enabled: true,
    this.lineColor,
    this.keyboardType = TextInputType.text,
    this.onSubmit,
    this.onChange,
    this.validator,
    this.errorText,
    this.onTap,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.initialText;
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
        maxLength: widget.maxLength == 0 || controller.text.length < widget.maxLength - 10 ? null : widget.maxLength,
        cursorColor: widget.lineColor ?? Colors.black,
        obscureText: widget.obscureText,
        style: TextStyle(
          color: widget.lineColor ?? Colors.black,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.label,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.lineColor?.withOpacity(0.5) ?? Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          labelStyle: widget.lineColor == null
              ? null
              : TextStyle(
                  color: widget.lineColor,
                ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: widget.lineColor ?? Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: widget.lineColor ?? Theme.of(context).primaryColor),
          ),
          errorText: widget.errorText,
        ),
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        onFieldSubmitted: widget.onSubmit,
        onChanged: (s) {
          setState(() {});
          widget.onChange?.call(s);
        },
        validator: (s) => widget.validator?.call(s ?? ''),
        onTap: widget.onTap,
      ),
    );
  }
}