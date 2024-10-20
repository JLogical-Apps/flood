import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:phone_number_text_input_formatter/phone_number_text_input_formatter.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledTextFieldPortField<S> extends HookWidget {
  final String fieldPath;

  final String? labelText;
  final Widget? label;
  final String? hintText;

  final Widget? leading;
  final IconData? leadingIcon;

  final bool enabled;

  final bool obscureText;

  final int? maxLines;

  final Future<List<S>> Function(String text)? suggestionsGetter;
  final Widget Function(S)? suggestionBuilder;
  final Function(S, TextEditingController)? onSuggestionPressed;
  final Duration? suggestionsDebounceDuration;

  const StyledTextFieldPortField({
    super.key,
    required this.fieldPath,
    this.labelText,
    this.label,
    this.hintText,
    this.leadingIcon,
    this.leading,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines = 1,
    this.suggestionsGetter,
    this.suggestionBuilder,
    this.onSuggestionPressed,
    this.suggestionsDebounceDuration,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<String?>(
      fieldPath: fieldPath,
      builder: (context, field, text, error) {
        return StyledTextField(
          text: text ?? '',
          labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
          label: label,
          showRequiredIndicator: field.findIsRequired(),
          leadingIcon: leadingIcon,
          leading: leading,
          errorText: error?.toString(),
          hintText: hintText,
          enabled: enabled,
          obscureText: obscureText,
          onChanged: (text) => port[fieldPath] = text,
          maxLines: maxLines ?? (field.findIsMultiline() ? 3 : null),
          keyboard: getKeyboardType(field),
          action: TextInputAction.next,
          inputFormatters: [
            if (field.findIsPhone()) ...[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              const NationalPhoneNumberTextInputFormatter.US(formatType: NationalPhoneNumberFormatType.domestic),
            ],
          ],
          suggestionsGetter: suggestionsGetter,
          suggestionBuilder: suggestionBuilder,
          onSuggestionPressed: onSuggestionPressed ?? (value, controller) => port[fieldPath] = value,
          suggestionsDebounceDuration: suggestionsDebounceDuration,
        );
      },
    );
  }

  TextInputType? getKeyboardType(PortField field) {
    if (field.findIsName()) {
      return TextInputType.name;
    }
    if (field.findIsEmail()) {
      return TextInputType.emailAddress;
    }
    if (field.findIsPhone()) {
      return TextInputType.phone;
    }
    if (field.findIsSecret()) {
      return TextInputType.visiblePassword;
    }
    if (field.findIsMultiline()) {
      return TextInputType.multiline;
    }
    if (field.findIsCurrency()) {
      return TextInputType.numberWithOptions(decimal: true);
    }

    return null;
  }
}
