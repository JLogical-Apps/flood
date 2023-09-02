import 'package:port_core/port_core.dart';

class PortFieldValidatorContext {
  final dynamic value;
  final Port port;

  PortFieldValidatorContext({required this.value, required this.port});

  PortFieldValidatorContext withValue(dynamic value) {
    return PortFieldValidatorContext(value: value, port: port);
  }

  PortFieldValidatorContext map<T2>(dynamic Function(dynamic value) mapper) {
    return PortFieldValidatorContext(value: mapper(value), port: port);
  }
}
