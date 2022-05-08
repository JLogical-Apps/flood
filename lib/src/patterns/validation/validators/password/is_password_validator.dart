import 'package:jlogical_utils/src/patterns/validation/util/composed_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validator.dart';

import '../../sync_validator.dart';

class IsPasswordValidator extends SyncComposedValidator<String> {
  final int minLength;

  IsPasswordValidator({this.minLength: 6});

  @override
  List<SyncValidator<String>> get validators => [
        Validator.required(),
        Validator.minLength(minLength),
      ];
}
