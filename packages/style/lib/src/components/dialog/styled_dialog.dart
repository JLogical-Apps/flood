import 'dart:async';

import 'package:flutter/material.dart';
import 'package:style/src/action/action_item.dart';
import 'package:style/src/components/input/styled_button.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_component.dart';
import 'package:utils/utils.dart';

class StyledDialog<T> extends StyleComponent {
  final Widget? title;
  final String? titleText;

  final Widget? body;
  final String? bodyText;

  final List<ActionItem> actions;

  StyledDialog({
    this.title,
    this.titleText,
    this.body,
    this.bodyText,
    this.actions = const [],
  });

  static StyledDialog<bool> yesNo({
    Widget? title,
    String? titleText,
    Widget? body,
    String? bodyText,
    FutureOr Function()? onAccept,
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
                  await onAccept?.call();
                  Navigator.of(context).pop(true);
                },
              ),
            ]),
          ],
        );
      }),
    );
  }

  static StyledDialog actionList({
    required BuildContext context,
    Widget? title,
    String? titleText,
    required List<ActionItem> actions,
  }) {
    return StyledDialog(
      body: StyledList.column(
          children: actions
              .map((action) => ListTile(
                    title: action.titleText
                            ?.mapIfNonNull((title) => StyledText.lg.bold.display.withColor(action.color)(title)) ??
                        action.title,
                    subtitle: action.descriptionText
                            ?.mapIfNonNull((description) => StyledText.body.withColor(action.color)(description)) ??
                        action.description,
                    leading: action.iconData?.mapIfNonNull((icon) => StyledIcon(
                              icon,
                              color: action.color,
                            )) ??
                        action.icon,
                    onTap: action.onPerform?.mapIfNonNull((onPerform) => () async {
                          Navigator.of(context).pop();
                          await onPerform(context);
                        }),
                  ))
              .toList()),
    );
  }
}
