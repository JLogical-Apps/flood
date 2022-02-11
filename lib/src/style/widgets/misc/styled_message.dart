import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Not a widget. Used to provide information for [Style.showMessage].
class StyledMessage {
  final String messageText;

  const StyledMessage({required this.messageText});

  Future<void> show(BuildContext context) async {
    final style = context.style();
    await style.showMessage(
      context: context,
      message: this,
    );
  }
}
