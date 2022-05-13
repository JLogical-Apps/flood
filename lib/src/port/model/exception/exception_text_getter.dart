abstract class ExceptionTextGetter {
  String getExceptionText(Object exception);

  static ExceptionTextGetter of(String exceptionTextGetter(Object exception)) {
    return SimpleExceptionTextGetter(exceptionTextGetter: exceptionTextGetter);
  }
}

class SimpleExceptionTextGetter implements ExceptionTextGetter {
  final String Function(Object exception) exceptionTextGetter;

  SimpleExceptionTextGetter({required this.exceptionTextGetter});

  @override
  String getExceptionText(Object exception) {
    return exceptionTextGetter(exception);
  }
}
