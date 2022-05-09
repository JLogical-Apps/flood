import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/form/ui/form_model_builder.dart';
import 'package:jlogical_utils/src/style/style.dart';

import '../../../form/export_core.dart';
import '../input/styled_button.dart';

/// Not a widget. Used to provide information for [Style.showDialog].
class StyledDialog<T> {
  /// The title of the dialog.
  final String? titleText;

  /// If [titleText] is null, uses this as the title of the dialog.
  final Widget? title;

  /// The body text of the dialog.
  final String? bodyText;

  /// If [bodyText] is null, uses this as the body of the dialog.
  final Widget? body;

  /// Transforms the result of the popped value.
  /// If null, the dialog simply returns the popped value.
  final T Function(dynamic result)? resultTransformer;

  /// Action to perform when the dialog is shown.
  final void Function()? onShown;

  /// Action to perform when the dialog is closed.
  final void Function(T? poppedValue)? onClosed;

  const StyledDialog({
    this.titleText,
    this.title,
    this.bodyText,
    this.body,
    this.resultTransformer,
    this.onShown,
    this.onClosed,
  });

  Future<T?> show(BuildContext context) async {
    final style = context.style();
    return await style.showDialog(
      context: context,
      dialog: this,
    );
  }

  static StyledDialog<bool> yesNo({
    required BuildContext context,
    String? titleText,
    Widget? title,
    required List<Widget> children,
    String confirmText: 'Ok',
    String cancelText: 'Cancel',
  }) {
    final style = context.style();

    return StyledDialog(
      titleText: titleText,
      title: title,
      resultTransformer: (value) => value == true,
      body: Column(
        children: [
          ...children,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledButton.low(
                text: cancelText,
                onTapped: () {
                  style.navigateBack(context: context, result: false);
                },
              ),
              SizedBox(width: 20),
              StyledButton.high(
                text: confirmText,
                onTapped: () {
                  style.navigateBack(context: context, result: true);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Wraps a styled dialog around a smart form and returns the data from the smart form.
  static StyledDialog<Map<String, dynamic>?> form({
    required BuildContext context,
    String? titleText,
    Widget? title,
    required FormModel form,
    required List<Widget> children,
    Widget Function(FormModel form)? confirmButtonBuilder,
  }) {
    final style = context.style();

    final _confirmButtonBuilder = confirmButtonBuilder ??
        (form) => StyledButton.high(
              text: 'Save',
              icon: Icons.save,
              onTapped: () async {
                final result = await form.submit();
                if (result.isValid) {
                  style.navigateBack(context: context, result: result.valueByName);
                }
              },
            );
    final confirmButton = _confirmButtonBuilder(form);

    return StyledDialog(
      titleText: titleText,
      title: title,
      body: FormModelBuilder(
        form: form,
        child: Column(
          children: [
            ...children,
            confirmButton,
          ],
        ),
      ),
    );
  }
}
