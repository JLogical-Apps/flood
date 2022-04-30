import 'package:example/debug_view/parameter/bool_parameter_form_builder.dart';
import 'package:example/debug_view/parameter/parameter_form_builder.dart';
import 'package:example/debug_view/parameter/string_parameter_form_builder.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'int_parameter_form_builder.dart';

class ParameterFormBuilderFactory {
  final WrapperResolver<CommandParameterStub, ParameterFormBuilder> formBuilderResolver = WrapperResolver([
    StringParameterFormBuilder(),
    IntParameterFormBuilder(),
    BoolParameterFormBuilder(),
  ]);

  ParameterFormBuilder? getParameterFormBuilderByParameterOrNull(CommandParameterStub stub) {
    return formBuilderResolver.resolveOrNull(stub);
  }
}
