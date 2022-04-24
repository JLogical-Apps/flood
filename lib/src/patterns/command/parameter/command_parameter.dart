import 'dart:core' as core;

import 'package:jlogical_utils/src/patterns/command/parameter/bool_parameter.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/required_parameter.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/string_parameter.dart';

import 'int_parameter.dart';

abstract class CommandParameter {
  core.String get type;

  core.bool matches(core.dynamic arg);

  static CommandParameter get int {
    return IntCommandParameter();
  }

  static CommandParameter get string {
    return StringCommandParameter();
  }

  static CommandParameter get bool {
    return BoolCommandParameter();
  }

  CommandParameter required() {
    return RequiredParameter(parent: this);
  }
}
