import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port_core/port_core.dart';
import 'package:utils/utils.dart';

Port<T> usePort<T>(Port<T> Function() portGetter, {Function()? onChanged}) {
  final port = useMemoized(portGetter);
  useValueStream(port.getPortX());
  useListen(port.getPortX(), (_) => onChanged?.call());
  return port;
}
