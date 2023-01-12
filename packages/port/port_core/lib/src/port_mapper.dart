import 'dart:async';

import 'package:port_core/port_core.dart';
import 'package:port_core/src/port_submit_result.dart';
import 'package:rxdart/rxdart.dart';

class PortMapper<T, R> with IsPort<R> {
  final Port<T> port;
  final FutureOr<R> Function(T source, Port<T> port) mapper;

  PortMapper({required this.port, required this.mapper});

  @override
  ValueStream<Map<String, PortValue>> getPortX() {
    return port.getPortX();
  }

  @override
  Map<String, PortValue> get portValueByName => port.portValueByName;

  @override
  void setPortValue({required String name, required PortValue portValue}) =>
      port.setPortValue(name: name, portValue: portValue);

  @override
  Future<PortSubmitResult<R>> submit() async {
    final sourceResult = await port.submit();
    final sourceData = sourceResult.dataOrNull;
    if (sourceData != null) {
      return PortSubmitResult(data: await mapper(sourceData, port));
    } else {
      return PortSubmitResult(data: null);
    }
  }
}
