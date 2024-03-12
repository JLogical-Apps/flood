import 'package:persistence_core/persistence_core.dart';
import 'package:port_core/src/file/allowed_file_types.dart';
import 'package:port_core/src/port_field.dart';

class AllowedFileTypesPortField<T extends CrossFile?, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final AllowedFileTypes allowedFileTypes;

  AllowedFileTypesPortField({required this.portField, required this.allowedFileTypes});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return AllowedFileTypesPortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      allowedFileTypes: allowedFileTypes,
    );
  }
}
