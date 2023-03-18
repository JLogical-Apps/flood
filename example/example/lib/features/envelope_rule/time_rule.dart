import 'package:jlogical_utils/jlogical_utils.dart';

abstract class TimeRule extends ValueObject {
  int getCentsRemaining({required DateTime now});
}
