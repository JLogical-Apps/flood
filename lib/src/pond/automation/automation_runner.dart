import 'package:args/args.dart';
import 'package:args/command_runner.dart' as args_command;

import '../../patterns/export_core.dart';
import 'automation_context.dart';
import 'automation_module.dart';
import 'parameters/parameter_arg_builder_factory.dart';

ParameterArgBuilderFactory _parameterArgBuilderFactory = ParameterArgBuilderFactory();

Future<void> runAutomation(List<String> args) async {
  final runner = args_command.CommandRunner('automate', 'Run an automation.');
  AutomationContext.global.modules
      .forEach((module) => _argCommandsFromModule(module).forEach((command) => runner.addCommand(command)));
  try {
    await runner.run(args);
  } on args_command.UsageException catch (e) {
    AutomationContext.global.print(e);
  }
}

List<args_command.Command> _argCommandsFromModule(AutomationModule module) {
  if (module.modifyCommandNames) {
    final argCommand = _ModuleCommand(name: module.name);
    module.commands.forEach((command) => argCommand.addSubcommand(_argCommandFromCommand(command)));
    return [argCommand];
  } else {
    return module.commands.map((command) => _argCommandFromCommand(command)).toList();
  }
}

_SimpleCommand _argCommandFromCommand(Command command) {
  final argCommand = _SimpleCommand(
    name: command.name,
    description: command.description ?? 'N/A',
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

class _ModuleCommand extends args_command.Command {
  @override
  final String name;

  @override
  String get description => '';

  _ModuleCommand({required this.name});
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
    this.onRun,
    String? category,
    Function(ArgParser args)? args,
  }) : this.category = category ?? '' {
    args?.call(argParser);
  }

  @override
  Future<void> run() async => await onRun?.call(argResults!);
}
