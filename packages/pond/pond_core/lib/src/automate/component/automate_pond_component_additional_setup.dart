import 'dart:async';

import 'package:pond_core/src/automate/command/automate_command.dart';
import 'package:pond_core/src/automate/component/automate_pond_component.dart';
import 'package:pond_core/src/automate/context/automate_pond_context.dart';

class AutomatePondComponentAdditionalSetup with IsAutomatePondComponentWrapper {
  @override
  final AutomatePondComponent automatePondComponent;

  final FutureOr Function(AutomatePondContext context)? onBeforeRegister;
  final FutureOr Function(AutomatePondContext context)? onAfterRegister;
  final FutureOr Function(AutomatePondContext context)? onBeforeLoad;
  final FutureOr Function(AutomatePondContext context)? onAfterLoad;
  final List<AutomateCommand> Function(List<AutomateCommand> existingCommands)? commandBuilder;

  AutomatePondComponentAdditionalSetup({
    required this.automatePondComponent,
    this.onBeforeRegister,
    this.onAfterRegister,
    this.onBeforeLoad,
    this.onAfterLoad,
    this.commandBuilder,
  });

  @override
  Future onRegister(AutomatePondContext context) async {
    await onBeforeRegister?.call(context);
    await automatePondComponent.onRegister(context);
    await onAfterRegister?.call(context);
  }

  @override
  Future onLoad(AutomatePondContext context) async {
    await onBeforeLoad?.call(context);
    await automatePondComponent.onLoad(context);
    await onAfterLoad?.call(context);
  }

  @override
  List<AutomateCommand> get commands =>
      commandBuilder?.call(automatePondComponent.commands) ?? automatePondComponent.commands;
}
