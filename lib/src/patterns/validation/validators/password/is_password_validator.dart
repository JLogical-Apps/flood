import 'package:jlogical_utils/src/patterns/validation/util/composed_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validator.dart';

class IsPasswordValidator extends ComposedValidator<String> {
  final int minLength;

  IsPasswordValidator({this.minLength: 6});

  @override
  List<Validator<String>> get validators => [
        Validator.required(),
        Validator.minLength(minLength),
      ];
}
