import 'package:jlogical_utils/src/patterns/command/command.dart';

abstract class DebuggableModule {
  List<Command> get debugCommands;
}
