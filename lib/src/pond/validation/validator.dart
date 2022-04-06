abstract class Validator {
  void validate();

  static Validator of(void validate()) {
    return _DefaultValidator(validate);
  }
}

extension ValidatorExtension on Validator {
  bool isValid() {
    try {
      validate();
      return true;
    } catch (e) {
      return false;
    }
  }
}

class _DefaultValidator implements Validator {
  final void Function() onValidate;

  const _DefaultValidator(this.onValidate);

  validate() => onValidate();
}
