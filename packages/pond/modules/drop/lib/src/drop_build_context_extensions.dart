import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

extension DropBuildContextExtensions on BuildContext {
  CoreDropComponent get coreDropComponent {
    return appPondContext.find<CoreDropComponent>();
  }
}
