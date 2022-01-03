abstract class Validator {
  void validate();

  static Validator of(void validate()) {
    return _DefaultValidator(validate);
  }
}

class _DefaultValidator implements Validator {
  final void Function() onValidate;

  const _DefaultValidator(this.onValidate);

  validate() => onValidate();
}
