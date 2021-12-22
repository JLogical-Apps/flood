import 'package:jlogical_utils/src/pond/validation/validator.dart';

mixin WithValidators implements Validator {
  List<Validator> get validators => [];

  void validate() {
    validators.forEach((validator) => validator.validate());
  }
}
