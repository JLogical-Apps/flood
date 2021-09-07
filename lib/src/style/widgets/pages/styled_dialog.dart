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

  /// Transforms the result of the popped value.
  /// If null, the dialog simply returns the popped value.
  final T Function(dynamic result)? resultTransformer;

  const StyledDialog({
    this.titleText,
    this.title,
    required this.body,
    this.resultTransformer,
  });

  Future<T> show(BuildContext context) async {
    final style = context.style();
    final poppedValue = await style.showDialog(
      context: context,
      dialog: this,
    );
    T result = resultTransformer.mapIfNonNull((transformer) => transformer(poppedValue)) ?? poppedValue;
    return result;
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
    final smartFormController = SmartFormController();

    return StyledDialog(
      titleText: titleText,
      title: title,
      resultTransformer: (value) => value == true,
      body: SmartForm(
        controller: smartFormController,
        child: Column(
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
