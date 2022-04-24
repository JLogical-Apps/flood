import 'command_parameter.dart';

class RequiredParameter extends CommandParameter {
  final CommandParameter parent;

  RequiredParameter({required this.parent}) : super(displayName: parent.displayName, description: parent.description);

  @override
  String get type => parent.type;

  @override
  bool matches(arg) {
    return arg != null;
  }
}
