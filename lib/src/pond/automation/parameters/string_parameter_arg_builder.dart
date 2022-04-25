import 'package:args/args.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/string_parameter.dart';
import 'package:jlogical_utils/src/pond/automation/parameters/parameter_arg_builder.dart';

class StringParameterArgBuilder extends ParameterArgBuilder<StringCommandParameter> {
  @override
  void register(String name, StringCommandParameter parameter, ArgParser args) {
    args.addOption(
      name,
      help: parameter.description,
      mandatory: parameter.isRequired,
    );
  }
}
