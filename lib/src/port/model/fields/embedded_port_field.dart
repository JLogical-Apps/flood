import 'dart:async';

import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/port/model/port.dart';
import 'package:jlogical_utils/src/port/model/port_field.dart';

class EmbeddedPortField extends PortField<Port> {
  bool enabled;

  EmbeddedPortField({required super.name, required Port port, this.enabled: true}) : super(initialValue: port) {
    withSimpleValidator(Validator.of((_) => port.submit(throwExceptionIfFail: true)));
  }

  @override
  FutureOr submitMapper(Port value) async {
    if (!enabled) {
      return null;
    }

    final result = await value.submit();
    return result.result;
  }
}
