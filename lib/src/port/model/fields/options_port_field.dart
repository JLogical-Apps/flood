import '../../../patterns/export_core.dart';
import '../port_field.dart';

class OptionsPortField<T> extends PortField<T?> {
  List<T> options;

  bool canBeNone;

  OptionsPortField({required super.name, super.initialValue, required this.options, this.canBeNone: true}) {
    withSimpleValidator(Validator.of((value) => Validator.isOneOf<T?>(options).validate(value)));
  }
}
