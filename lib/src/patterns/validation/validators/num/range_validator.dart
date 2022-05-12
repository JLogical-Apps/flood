import 'package:jlogical_utils/src/patterns/validation/sync_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/util/composed_validator.dart';

import '../../validator.dart';

class RangeValidator extends SyncComposedValidator<num> {
  final num min;
  final num max;

  RangeValidator({required this.min, required this.max});

  @override
  List<SyncValidator<num>> get validators => [
        Validator.isLessThan(max),
        Validator.isGreaterThan(min),
      ];
}
