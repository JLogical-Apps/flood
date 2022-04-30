import 'package:args/args.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';
import 'package:jlogical_utils/src/patterns/wrapper/with_subtype_wrapper.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';

abstract class ParameterArgBuilder<T extends CommandParameter> extends Wrapper<CommandParameter>
    with WithSubtypeWrapper<T, CommandParameter> {
  /// Register the [parameter] that has [name] with [args].
  void register(String name, T parameter, ArgParser args);
}
