import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port_core/port_core.dart';
import 'package:utils/utils.dart';

Port<T> usePort<T>(Port<T> Function() portGetter) {
  final port = useMemoized(portGetter);
  useValueStream(port.getPortX());
  return port;
}
