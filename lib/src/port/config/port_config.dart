import 'package:jlogical_utils/src/port/model/exception/exception_text_getter.dart';
import 'package:jlogical_utils/src/port/model/exception/to_string_exception_text_getter.dart';

class PortConfig {
  final ExceptionTextGetter defaultExceptionTextGetter;

  PortConfig({ExceptionTextGetter? defaultExceptionTextGetter})
      : this.defaultExceptionTextGetter = defaultExceptionTextGetter ?? ToStringExceptionTextGetter();
}
