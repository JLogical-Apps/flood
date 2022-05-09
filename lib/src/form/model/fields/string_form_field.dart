import '../form_field_model.dart';
import '../validation/form_field_validator.dart';

class StringFormField extends FormFieldModel<String> {
  StringFormField({required String name, String? initialValue})
      : super(
          name: name,
          initialValue: initialValue ?? '',
        );
}
