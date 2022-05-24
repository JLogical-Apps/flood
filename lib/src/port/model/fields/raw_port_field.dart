import 'dart:typed_data';

import '../port_field.dart';

class RawPortField extends PortField<Uint8List?> {
  RawPortField({required super.name, super.initialValue});
}
