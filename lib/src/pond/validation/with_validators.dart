import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/validation/validator.dart';

mixin WithValidators on Record {
  List<Validator> get validators => [];

  void onValidate() {
    final _state = state;
    validators.forEach((validator) => validator.validate(_state));
  }
}
