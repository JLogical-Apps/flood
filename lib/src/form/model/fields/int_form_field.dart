import '../form_field_model.dart';
import '../validation/form_field_validator.dart';

class IntFormField extends FormFieldModel<int> {
  IntFormField({required String name, int? initialValue})
      : super(
          name: name,
          initialValue: initialValue ?? 0,
        );
}
