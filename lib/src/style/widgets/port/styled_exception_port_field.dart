import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/port/model/exception/exception_text_getter.dart';

import '../../../port/export.dart';
import '../../../widgets/export.dart';
import '../text/styled_error_text.dart';

class StyledExceptionPortField extends PortExceptionFieldWidget with WithPortExceptionTextGetter {
  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledExceptionPortField({required super.name, this.exceptionTextGetterOverride});

  @override
  Widget buildException(BuildContext context, Object exception) {
    final exceptionText = getExceptionText(exception);
    if (exceptionText == null) {
      return EmptyWidget();
    }

    return StyledErrorText(exceptionText);
  }
}
