import 'dart:typed_data';

class Asset {
  final String? id;
  final String name;
  final Uint8List value;

  const Asset({this.id, required this.name, required this.value});
}
