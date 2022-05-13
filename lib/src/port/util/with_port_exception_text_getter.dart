import '../model/exception/exception_text_getter.dart';
import '../model/port.dart';

mixin WithPortExceptionTextGetter {
  ExceptionTextGetter? get exceptionTextGetterOverride;

  ExceptionTextGetter getDefaultExceptionTextGetter() => Port.config.defaultExceptionTextGetter;

  String? getExceptionText(Object? exception) {
    if (exception == null) {
      return null;
    }

    final exceptionTextGetter = exceptionTextGetterOverride ?? getDefaultExceptionTextGetter();
    return exceptionTextGetter.getExceptionText(exception);
  }
}
