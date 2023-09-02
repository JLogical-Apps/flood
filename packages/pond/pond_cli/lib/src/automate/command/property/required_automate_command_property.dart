import 'package:pond_cli/src/automate/command/property/automate_command_property.dart';

class RequiredAutomateCommandProperty<G, S> with IsAutomateCommandProperty<G, S> {
  final AutomateCommandProperty<G?, S?> parent;

  RequiredAutomateCommandProperty({required this.parent});

  @override
  String get name => parent.name;

  @override
  G get value => parent.value ?? (throw Exception('Required but not found! [$name]'));

  @override
  void set(S value) => parent.set(value);

  @override
  void fromValue(String rawValue) {
    parent.fromValue(rawValue);
  }

  @override
  void validate() {
    if (parent.value == null) {
      throw Exception('Required but not found! [$name]');
    }
    parent.validate();
  }
}
