import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:provider/provider.dart';

/// Builds on every update to the surrounding SmartForm.
/// Can be used to dynamically show/hide SmartFormFields.
class SmartFormUpdateBuilder extends HookWidget {
  /// Builds a widget in response to the SmartForm updating.
  final Widget Function(BuildContext context, SmartFormController smartFormController) builder;

  const SmartFormUpdateBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var smartFormController = context.select((SmartFormController value) => value);

    useValueStream(smartFormController.dataByNameX);

    return builder(context, smartFormController);
  }
}
