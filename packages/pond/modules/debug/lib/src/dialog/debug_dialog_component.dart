import 'package:debug/src/dialog/debug_dialog_context.dart';
import 'package:flutter/material.dart';

abstract class DebugDialogComponent {
  Widget render(BuildContext context, DebugDialogContext debugContext);
}

mixin IsDebugDialogComponent implements DebugDialogComponent {}

abstract class DebugDialogComponentWrapper implements DebugDialogComponent {
  DebugDialogComponent get debugDialogComponent;
}

mixin IsDebugDialogComponentWrapper implements DebugDialogComponentWrapper {
  @override
  Widget render(BuildContext context, DebugDialogContext debugContext) =>
      debugDialogComponent.render(context, debugContext);
}
