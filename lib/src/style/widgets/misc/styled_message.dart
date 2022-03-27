import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Not a widget. Used to provide information for [Style.showMessage].
class StyledMessage {
  final String messageText;
  final Duration showDuration;
  final Color? backgroundColorOverride;

  const StyledMessage({
    required this.messageText,
    this.showDuration: const Duration(seconds: 6),
    this.backgroundColorOverride,
  });

  const StyledMessage.error({required this.messageText, this.showDuration: const Duration(seconds: 6)})
      : backgroundColorOverride = Colors.red;

  Future<void> show(BuildContext context) async {
    final style = context.style();
    await style.showMessage(
      context: context,
      message: this,
    );
  }
}
