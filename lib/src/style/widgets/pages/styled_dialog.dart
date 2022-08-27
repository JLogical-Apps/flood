import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style.dart';

import '../../../form/export.dart';
import '../../../port/export.dart';
import '../../../port/export_core.dart';
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

  /// Wraps a styled dialog around a smart port and returns the data from the smart port.
  static StyledDialog<T> port<T>({
    required BuildContext context,
    String? titleText,
    Widget? title,
    required Port<T> port,
    required List<Widget> children,
    Widget Function(Port port)? confirmButtonBuilder,
  }) {
    final style = context.style();

    final _confirmButtonBuilder = confirmButtonBuilder ??
        (port) => StyledButton.high(
              text: 'Save',
              icon: Icons.save,
              onTapped: () async {
                final result = await port.submit();
                if (result.isValid) {
                  style.navigateBack(context: context, result: result.result);
                }
              },
            );
    final confirmButton = _confirmButtonBuilder(port);

    return StyledDialog(
      titleText: titleText,
      title: title,
      body: PortBuilder(
        port: port,
        child: Column(
          children: [
            ...children,
            confirmButton,
          ],
        ),
      ),
    );
  }

  /// Wraps a styled dialog around a smart form and returns the data from the smart form.
  static StyledDialog<Map<String, dynamic>?> smartForm({
    required BuildContext context,
    String? titleText,
    Widget? title,
    required List<Widget> children,
    Widget Function(SmartFormController controller)? confirmButtonBuilder,
    FutureOr<Map<String, String>?> postValidator(Map<String, dynamic> data)?,
    void onFormChange(SmartFormController controller)?,
  }) {
    final style = context.style();
    final smartFormController = SmartFormController();

    final _confirmButtonBuilder = confirmButtonBuilder ??
        (controller) => StyledButton.high(
              text: 'Save',
              icon: Icons.save,
              onTapped: () async {
                final result = await controller.validate();
                if (result.isValid) {
                  style.navigateBack(context: context, result: result.valueByName);
                }
              },
            );
    final confirmButton = _confirmButtonBuilder(smartFormController);

    StreamSubscription? listener;

    return StyledDialog(
      titleText: titleText,
      title: title,
      onShown: onFormChange == null
          ? null
          : () {
              listener =
                  smartFormController.valueByNameX.listen((valueByName) => onFormChange.call(smartFormController));
            },
      onClosed: onFormChange == null ? null : (_) => listener?.cancel(),
      body: SmartForm(
        controller: smartFormController,
        child: Column(
          children: [
            ...children,
            confirmButton,
          ],
        ),
        postValidator: postValidator,
      ),
    );
  }
}
