import 'dart:core' as core;

import 'package:jlogical_utils/src/patterns/command/parameter/bool_parameter.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/string_parameter.dart';

import 'int_parameter.dart';

abstract class CommandParameter {
  final core.String? displayName;
  final core.String? description;

  core.bool isRequired = false;

  CommandParameter({this.displayName, this.description});

  core.String get type;

  core.bool matches(core.dynamic arg);

  static CommandParameter int({core.String? displayName, core.String? description}) {
    return IntCommandParameter(displayName: displayName, description: description);
  }

  static CommandParameter string({core.String? displayName, core.String? description}) {
    return StringCommandParameter(displayName: displayName, description: description);
  }

  static CommandParameter bool({core.String? displayName, core.String? description}) {
    return BoolCommandParameter(displayName: displayName, description: description);
  }

  CommandParameter required() {
    isRequired = true;
    return this;
  }
}
