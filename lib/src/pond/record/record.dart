import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/validation/has_validation.dart';
import 'package:jlogical_utils/src/pond/validation/with_validation.dart';

abstract class Record = Object with WithValidation implements Stateful, HasValidation;
