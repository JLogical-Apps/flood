import 'package:pond_cli/src/automate/command/property/automate_command_property.dart';

class WithFallbackAutomateCommandProperty<G, S> with IsAutomateCommandProperty<G, S> {
  final AutomateCommandProperty<G?, S?> parent;
  final G Function() fallback;

  WithFallbackAutomateCommandProperty({required this.parent, required this.fallback});

  @override
  String get name => parent.name;

  @override
  G get value => parent.value ?? fallback();

  @override
  void set(S value) => parent.set(value);

  @override
  void fromValue(String rawValue) {
    parent.fromValue(rawValue);
  }

  @override
  void validate() {
    parent.validate();
  }
}
