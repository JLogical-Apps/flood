import 'dart:async';

import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/port/model/port.dart';
import 'package:jlogical_utils/src/port/model/port_field.dart';
import 'package:rxdart/rxdart.dart';

class EmbeddedPortField extends PortField<Port> {
  BehaviorSubject<bool> _enabledX;

  ValueStream<bool> get enabledX => _enabledX;

  bool get enabled => _enabledX.value;

  set enabled(bool value) {
    _enabledX.value = value;
  }

  EmbeddedPortField({required super.name, required Port port, bool enabled: true})
      : _enabledX = BehaviorSubject.seeded(enabled),
        super(initialValue: port) {
    withSimpleValidator(Validator.of((_) async {
      if (!enabled) {
        return;
      }

      await port.submit(throwExceptionIfFail: true);
    }));
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
