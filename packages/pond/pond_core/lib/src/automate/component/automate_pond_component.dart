import 'dart:async';

import 'package:pond_core/src/automate/command/automate_command.dart';
import 'package:pond_core/src/automate/component/automate_pond_component_additional_setup.dart';
import 'package:pond_core/src/automate/context/automate_pond_context.dart';

abstract class AutomatePondComponent {
  Future onRegister(AutomatePondContext context);

  Future onLoad(AutomatePondContext context);

  List<AutomateCommand> get commands;
}

mixin IsAutomatePondComponent implements AutomatePondComponent {
  @override
  Future onRegister(AutomatePondContext context) async {}

  @override
  Future onLoad(AutomatePondContext context) async {}

  @override
  List<AutomateCommand> get commands;
}

abstract class AutomatePondComponentWrapper implements AutomatePondComponent {
  AutomatePondComponent get automatePondComponent;
}

mixin IsAutomatePondComponentWrapper implements AutomatePondComponentWrapper {
  @override
  Future onRegister(AutomatePondContext context) {
    return automatePondComponent.onRegister(context);
  }

  @override
  Future onLoad(AutomatePondContext context) {
    return automatePondComponent.onLoad(context);
  }

  @override
  List<AutomateCommand> get commands => automatePondComponent.commands;
}

extension AutomatePondComponentExtension on AutomatePondComponent {
  void registerTo(AutomatePondContext context) {
    onRegister(context);
  }

  Future load(AutomatePondContext context) {
    return onLoad(context);
  }

  AutomatePondComponentAdditionalSetup withAdditionalSetup({
    void Function(AutomatePondContext context)? onBeforeRegister,
    void Function(AutomatePondContext context)? onAfterRegister,
    FutureOr Function(AutomatePondContext context)? onBeforeLoad,
    FutureOr Function(AutomatePondContext context)? onAfterLoad,
  }) {
    return AutomatePondComponentAdditionalSetup(
      automatePondComponent: this,
      onBeforeRegister: onBeforeRegister,
      onAfterRegister: onAfterRegister,
      onBeforeLoad: onBeforeLoad,
      onAfterLoad: onAfterLoad,
    );
  }
}
