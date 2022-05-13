import '../../../patterns/export_core.dart';
import '../port.dart';

class PortSubmitException extends ValidationException<Port> {
  final Map<String, dynamic> fieldExceptionByName;

  PortSubmitException({required this.fieldExceptionByName, required super.failedValue});

  operator [](String name) {
    return fieldExceptionByName[name];
  }
}
