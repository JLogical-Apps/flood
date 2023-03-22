import 'dart:async';

import 'package:port_core/port_core.dart';
import 'package:port_core/src/port_submit_result.dart';
import 'package:rxdart/rxdart.dart';

class PortMapper<T, R> with IsPort<R> {
  final Port<T> port;
  final FutureOr<R> Function(T source, Port<T> port) mapper;

  PortMapper({required this.port, required this.mapper});

  @override
  ValueStream<Map<String, PortField>> getPortX() {
    return port.getPortX();
  }

  @override
  void setPortField({required String name, required PortField portField}) =>
      port.setPortField(name: name, portField: portField);

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
