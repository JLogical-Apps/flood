import 'package:jlogical_utils/src/port/model/exception/exception_text_getter.dart';

class ToStringExceptionTextGetter implements ExceptionTextGetter {
  @override
  String getExceptionText(Object exception) {
    return exception.toString();
  }
}
