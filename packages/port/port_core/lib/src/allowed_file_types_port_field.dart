import 'package:asset_core/asset_core.dart';
import 'package:port_core/src/port_field.dart';

class AllowedFileTypesPortField<T, S> with IsPortFieldWrapper<T, S> {
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
