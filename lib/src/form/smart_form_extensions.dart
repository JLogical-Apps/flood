import 'package:flutter/material.dart';

import '../../jlogical_utils.dart';

extension SmartFormStyleExtensions on Style {
  /// Wrap the contents of [styledDialog] in a SmartForm and return the data returned from the dialog.
  Future<Map<String, dynamic>?> showSmartFormDialog({
    required BuildContext context,
    required StyledDialog styledDialog,
    Widget Function(SmartFormController controller)? confirmButtonBuilder,
  }) {
    final _confirmButtonBuilder = confirmButtonBuilder ??
        (controller) => StyledButton.high(
              text: 'Save',
              icon: Icons.save,
              onTapped: () async {
                final result = await controller.validate();
                if (result.isValid) {
                  navigateBack(context: context, result: result.valueByName);
                }
              },
            );
    final smartFormController = SmartFormController();
    final confirmButton = _confirmButtonBuilder(smartFormController);
    return this.showDialog(
      context: context,
      dialog: StyledDialog(
        titleText: styledDialog.titleText,
        title: styledDialog.title,
        body: SmartForm(
          controller: smartFormController,
          child: Column(
            children: [
              styledDialog.body,
              confirmButton,
            ],
          ),
        ),
      ),
    );
  }
}
