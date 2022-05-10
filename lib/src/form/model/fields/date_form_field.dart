import '../form_field_model.dart';

class StringFormField extends FormFieldModel<DateTime> {
  StringFormField({required String name, DateTime? initialValue})
      : super(
          name: name,
          initialValue: initialValue ?? DateTime.now(),
        );
}
