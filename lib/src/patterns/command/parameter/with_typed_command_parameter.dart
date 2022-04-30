import 'command_parameter.dart';

mixin WithTypedCommandParameter<T> implements CommandParameter {
  @override
  String get type => T.toString().toLowerCase();

  @override
  bool matches(dynamic arg) {
    return arg is T?;
  }
}
