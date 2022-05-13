import 'package:jlogical_utils/src/patterns/validation/sync_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/util/composed_validator.dart';

import '../../validator.dart';

class RangeValidator<N extends num> extends SyncComposedValidator<N?> {
  final N min;
  final N max;

  RangeValidator({required this.min, required this.max});

  @override
  List<SyncValidator<N?>> get validators => [
        Validator.isLessThan(max),
        Validator.isGreaterThan(min),
      ];
}
