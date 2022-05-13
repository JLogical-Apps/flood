import '../model/exception/exception_text_getter.dart';
import '../model/port.dart';
import '../model/port_field.dart';
import '../ui/port_field_widget.dart';

mixin WithPortFieldWidgetExceptionTextGetter<F extends PortField<T>, T> on PortFieldWidget<F, T> {
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
