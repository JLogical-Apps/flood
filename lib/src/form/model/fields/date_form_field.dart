import '../form_field_model.dart';

class DateFormField extends FormFieldModel<DateTime> {
  DateFormField({required String name, DateTime? initialValue})
      : super(
          name: name,
          initialValue: initialValue ?? DateTime.now(),
        );
}
