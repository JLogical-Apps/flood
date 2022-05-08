import '../form_model.dart';

class FormFieldValidationContext<T> {
  final T value;
  final FormModel form;

  const FormFieldValidationContext({required this.value, required this.form});
}
