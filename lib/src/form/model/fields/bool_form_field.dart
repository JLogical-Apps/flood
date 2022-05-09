import '../form_field_model.dart';
import '../validation/form_field_validator.dart';

class BoolFormField extends FormFieldModel<bool> {
  BoolFormField({required String name, bool? initialValue})
      : super(
          name: name,
          initialValue: initialValue ?? false,
        );
}
