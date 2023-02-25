import 'package:flutter/material.dart';
import 'package:style/src/components/input/styled_button.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_component.dart';
import 'package:utils/utils.dart';

class StyledDialog<T> extends StyleComponent {
  final Widget? title;
  final String? titleText;

  final Widget? body;
  final String? bodyText;

  StyledDialog({
    this.title,
    this.titleText,
    this.body,
    this.bodyText,
  });

  static StyledDialog<bool> yesNo({
    Widget? title,
    String? titleText,
    Widget? body,
    String? bodyText,
  }) {
    body = bodyText?.mapIfNonNull((text) => StyledText.body(text)) ?? body;
    return StyledDialog(
      title: title,
      titleText: titleText,
      body: Builder(builder: (context) {
        return StyledList.column(
          children: [
            if (body != null) body,
            StyledList.row.centered(children: [
              StyledButton(
                labelText: 'Cancel',
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
              ),
              StyledButton.strong(
                labelText: 'Ok',
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
              ),
            ]),
          ],
        );
      }),
    );
  }
}
