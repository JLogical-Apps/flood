import '../../../patterns/export_core.dart';
import '../port_field.dart';

class OptionsPortField<T> extends PortField<T?> {
  final List<T> options;

  final bool canBeNone;

  OptionsPortField({required super.name, super.initialValue, required this.options, this.canBeNone: true}) {
    withSimpleValidator(Validator.isOneOf(options));
  }
}
