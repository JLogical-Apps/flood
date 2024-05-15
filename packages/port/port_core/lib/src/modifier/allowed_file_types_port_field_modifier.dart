import 'package:asset_core/asset_core.dart';
import 'package:port_core/src/allowed_file_types_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class AllowedFileTypesPortFieldNodeModifier extends WrapperPortFieldNodeModifier<AllowedFileTypesPortField> {
  AllowedFileTypesPortFieldNodeModifier({required super.modifierGetter});

  @override
  AllowedFileTypes? getAllowedFileTypes(AllowedFileTypesPortField portField) {
    return portField.allowedFileTypes;
  }
}
