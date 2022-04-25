import 'package:args/args.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/bool_parameter.dart';
import 'package:jlogical_utils/src/pond/automation/parameters/parameter_arg_builder.dart';

class BoolParameterArgBuilder extends ParameterArgBuilder<BoolCommandParameter> {
  @override
  void register(String name, BoolCommandParameter parameter, ArgParser args) {
    args.addFlag(
      name,
      help: parameter.description,
      defaultsTo: false,
    );
  }
}
