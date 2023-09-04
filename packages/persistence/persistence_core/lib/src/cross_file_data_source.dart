import 'dart:convert';
import 'dart:typed_data';

import 'package:persistence_core/src/crossfile/cross_file.dart';
import 'package:persistence_core/src/data_source.dart';

class CrossFileDataSource with IsDataSourceWrapper<String> {
  final CrossFile file;

  CrossFileDataSource({required this.file});

  @override
  DataSource<String> get dataSource => DataSource.static.rawCrossFile(file).map(
        getMapper: (bytes) => utf8.decode(bytes),
        setMapper: (text) => Uint8List.fromList(utf8.encode(text)),
      );
}
