import 'package:port_core/port_core.dart';

class PortFieldValidatorContext<T> {
  final T value;
  final Port port;

  PortFieldValidatorContext({required this.value, required this.port});

  PortFieldValidatorContext<T> withValue(T value) {
    return PortFieldValidatorContext(value: value, port: port);
  }

  PortFieldValidatorContext<T2> map<T2>(T2 Function(T value) mapper) {
    return PortFieldValidatorContext<T2>(value: mapper(value), port: port);
  }
}
