import 'package:args/args.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/int_parameter.dart';
import 'package:jlogical_utils/src/pond/automation/parameters/parameter_arg_builder.dart';

class IntParameterArgBuilder extends ParameterArgBuilder<IntCommandParameter> {
  @override
  void register(String name, IntCommandParameter parameter, ArgParser args) {
    args.addOption(
      name,
      help: parameter.description,
      mandatory: parameter.isRequired,
    );
  }
}
