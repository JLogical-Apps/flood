import 'package:jlogical_utils/src/port/model/validation/port_submit_exception.dart';

class PortResult {
  final Map<String, dynamic>? valueByName;
  final PortSubmitException? _exception;

  const PortResult({this.valueByName, PortSubmitException? exception}) : _exception = exception;

  bool get isValid => _exception != null;

  PortSubmitException get exception => _exception!;

  operator [](String name) {
    return valueByName![name];
  }
}
