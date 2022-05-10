import '../form_field_model.dart';

class OptionsFormField<T> extends FormFieldModel<T?> {
  final List<T> options;

  final bool canBeNone;

  OptionsFormField({required String name, T? initialValue, required this.options, this.canBeNone: true})
      : super(
          name: name,
          initialValue: initialValue,
        );
}
