import 'package:pond_cli/src/automate/command/property/required_automate_command_property.dart';
import 'package:pond_cli/src/automate/command/property/with_fallback_automate_command_property.dart';

abstract class AutomateCommandProperty<G, S> {
  String get name;

  G get value;

  void set(S value);

  void fromValue(String rawValue);

  void validate();
}

extension NullableAutomateCommandPropertyExtensions<G, S> on AutomateCommandProperty<G?, S?> {
  RequiredAutomateCommandProperty<G, S> required() {
    return RequiredAutomateCommandProperty<G, S>(parent: this);
  }

  WithFallbackAutomateCommandProperty<G, S> withFallback(G Function() fallback) {
    return WithFallbackAutomateCommandProperty<G, S>(parent: this, fallback: fallback);
  }
}

mixin IsAutomateCommandProperty<G, S> implements AutomateCommandProperty<G, S> {
  @override
  void validate() {}
}

abstract class AutomateCommandPropertyWrapper<G, S> implements AutomateCommandProperty<G, S> {
  AutomateCommandProperty<G, S> get routeProperty;
}

mixin IsAutomateCommandPropertyWrapper<G, S> implements AutomateCommandPropertyWrapper<G, S> {
  @override
  String get name => routeProperty.name;

  @override
  get value => routeProperty.value;

  @override
  void fromValue(String rawValue) {
    routeProperty.fromValue(rawValue);
  }

  @override
  void validate() {
    routeProperty.validate();
  }
}
