import 'package:args/args.dart';
import 'package:args/command_runner.dart' as args_command;

import '../../patterns/export_core.dart';
import 'automation_context.dart';
import 'parameters/parameter_arg_builder_factory.dart';

ParameterArgBuilderFactory _parameterArgBuilderFactory = ParameterArgBuilderFactory();

Future<void> runAutomation(List<String> args) async {
  final runner = args_command.CommandRunner('automate', 'Run an automation.');
  AutomationContext.global.commands.forEach((command) => runner.addCommand(_argCommandFromCommand(command)));
  try {
    await runner.run(args);
  } on args_command.UsageException catch (e) {
    AutomationContext.global.print(e);
  }
}

_SimpleCommand _argCommandFromCommand(Command command) {
  final argCommand = _SimpleCommand(
    name: command.name,
    description: command.description ?? 'N/A',
    category: command.category,
    args: (args) {
      command.parameters.forEach((name, param) {
        _parameterArgBuilderFactory.getParameterArgBuilderByValueOrNull(param)!.register(name, param, args);
      });
    },
    onRun: (results) {
      final args = command.parameters.map((name, param) => MapEntry(name, results[name]));
      AutomationContext.global.args = args;
      return command.run(args);
    },
  );
  return argCommand;
}

class _SimpleCommand extends args_command.Command {
  @override
  final String name;

  @override
  final String description;

  @override
  final String category;

  final Future<void> Function(ArgResults args)? onRun;

  _SimpleCommand({
    required this.name,
    required this.description,
    required this.onRun,
    String? category,
    Function(ArgParser args)? args,
  }) : this.category = category ?? '' {
    args?.call(argParser);
  }

  @override
  Future<void> run() async => await onRun?.call(argResults!);
}
