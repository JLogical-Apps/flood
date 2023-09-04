import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:persistence_core/src/data_source.dart';

class FileDataSource with IsDataSourceWrapper<String> {
  final File file;

  FileDataSource({required this.file});

  @override
  DataSource<String> get dataSource => DataSource.static.rawFile(file).map(
        getMapper: (bytes) => utf8.decode(bytes),
        setMapper: (text) => Uint8List.fromList(utf8.encode(text)),
      );
}
