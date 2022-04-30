import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';
import 'package:jlogical_utils/src/pond/automation/parameters/bool_parameter_arg_builder.dart';
import 'package:jlogical_utils/src/pond/automation/parameters/int_parameter_arg_builder.dart';
import 'package:jlogical_utils/src/pond/automation/parameters/parameter_arg_builder.dart';
import 'package:jlogical_utils/src/pond/automation/parameters/string_parameter_arg_builder.dart';

import '../../../patterns/resolver/wrapper_resolver.dart';

class ParameterArgBuilderFactory {
  final WrapperResolver<CommandParameter, ParameterArgBuilder> formBuilderResolver = WrapperResolver([
    StringParameterArgBuilder(),
    IntParameterArgBuilder(),
    BoolParameterArgBuilder(),
  ]);

  ParameterArgBuilder? getParameterArgBuilderByValueOrNull(CommandParameter value) {
    return formBuilderResolver.resolveOrNull(value);
  }
}
