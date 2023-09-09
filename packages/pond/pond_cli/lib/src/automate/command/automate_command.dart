import 'dart:async';

import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

abstract class AutomateCommand<A extends AutomateCommand<dynamic>> {
  String get name;

  String get description;

  Future<void> onRun(AutomateCommandContext context);

  A copy();

  AutomatePathDefinition get pathDefinition;

  List<AutomateCommandProperty> get parameters => [];

  static AutomateCommand simple({
    required String name,
    required String description,
    required FutureOr Function(AutomateCommandContext context) runner,
    required AutomatePathDefinition pathDefinition,
    List<AutomateCommandProperty> parameters = const [],
  }) =>
      _AutomateCommandImpl(
        name: name,
        description: description,
        runner: runner,
        pathDefinition: pathDefinition,
        parameters: parameters,
      );
}

class _AutomateCommandImpl implements AutomateCommand<_AutomateCommandImpl> {
  @override
  final String name;

  @override
  final String description;

  @override
  final AutomatePathDefinition pathDefinition;

  @override
  final List<AutomateCommandProperty> parameters;

  final FutureOr Function(AutomateCommandContext context) runner;

  _AutomateCommandImpl({
    required this.name,
    required this.description,
    required this.runner,
    required this.pathDefinition,
    required this.parameters,
  });

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    await runner(context);
  }

  @override
  _AutomateCommandImpl copy() {
    return _AutomateCommandImpl(
      name: name,
      description: description,
      runner: runner,
      pathDefinition: pathDefinition,
      parameters: parameters,
    );
  }
}

extension AutomateCommandDefaults<A extends AutomateCommand> on AutomateCommand<A> {
  Future<void> run(AutomateCommandContext context) async {
    await onRun(context);
  }

  A fromPath(AutomatePath automatePath) {
    if (!pathDefinition.matches(automatePath)) {
      throw Exception('[$automatePath] does not match this command!');
    }

    final instance = copy();

    for (var i = 0; i < automatePath.segments.length; i++) {
      final uriSegment = automatePath.segments[i];
      final routeSegment = instance.pathDefinition.segments[i];

      routeSegment.onMatch(uriSegment);
    }

    for (final parameter in instance.parameters) {
      automatePath.parameters[parameter.name]?.mapIfNonNull((value) => parameter.fromValue(value));
      parameter.validate();
    }

    return instance;
  }

  FieldAutomateCommandProperty<T> field<T>({required String name}) => FieldAutomateCommandProperty(name: name);
}
