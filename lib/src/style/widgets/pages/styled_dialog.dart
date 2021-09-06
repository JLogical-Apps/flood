import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Not a widget. Used to provide information for [Style.showDialog].
class StyledDialog<T> {
  /// The title of the dialog.
  final String? titleText;

  /// If [titleText] is null, uses this as the title of the dialog.
  final Widget? title;

  /// The body of the dialog.
  final Widget body;

  const StyledDialog({
    this.titleText,
    this.title,
    required this.body,
  });

  Future<T?> show(BuildContext context) async {
    final style = context.style();
    final result = await style.showDialog<T?>(
      context: context,
      dialog: this,
    );
    return result;
  }

  static StyledDialog<bool> yesNo({
    required BuildContext context,
    String? titleText,
    Widget? title,
    required List<Widget> children,
    String confirmText: 'Ok',
  }) {
    final style = context.style();
    final smartFormController = SmartFormController();

    return StyledDialog(
      titleText: titleText,
      title: title,
      body: SmartForm(
        controller: smartFormController,
        child: Column(
          children: [
            ...children,
            StyledButton.high(
              text: confirmText,
              onTapped: () {
                style.navigateBack(context: context, result: true);
              },
            ),
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

    return StyledDialog(
      titleText: titleText,
      title: title,
      body: SmartForm(
        controller: smartFormController,
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
