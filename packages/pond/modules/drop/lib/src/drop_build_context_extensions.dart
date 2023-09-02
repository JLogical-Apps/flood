import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

extension DropBuildContextExtensions on BuildContext {
  DropCoreComponent get dropCoreComponent {
    return appPondContext.find<DropCoreComponent>();
  }
}
