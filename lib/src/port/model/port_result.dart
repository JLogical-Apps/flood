import 'package:jlogical_utils/src/port/model/validation/port_submit_exception.dart';

class PortResult<T> {
  final T? result;
  final PortSubmitException? _exception;

  const PortResult({this.result, PortSubmitException? exception}) : _exception = exception;

  bool get isValid => _exception == null;

  PortSubmitException get exception => _exception!;

  operator [](String name) {
    return (result as Map)[name];
  }
}
