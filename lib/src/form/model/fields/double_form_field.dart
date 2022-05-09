import '../form_field_model.dart';
import '../validation/form_field_validator.dart';

class DoubleFormField extends FormFieldModel<double> {
  DoubleFormField({required String name, double? initialValue})
      : super(
          name: name,
          initialValue: initialValue ?? 0,
        );
}
