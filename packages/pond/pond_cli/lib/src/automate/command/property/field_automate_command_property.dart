import 'package:pond_cli/src/automate/command/property/automate_command_property.dart';
import 'package:utils_core/utils_core.dart';

class FieldAutomateCommandProperty<T> with IsAutomateCommandProperty<T?, T?> {
  @override
  final String name;

  @override
  T? value;

  @override
  void set(T? value) => this.value = value;

  FieldAutomateCommandProperty({required this.name});

  @override
  void fromValue(String rawValue) {
    value = coerce<T>(rawValue);
  }
}
