import 'dart:convert';

import 'package:persistence_core/persistence_core.dart';

class Base64DataSource with IsDataSourceWrapper<String> {
  final DataSource<String> sourceDataSource;

  Base64DataSource({required this.sourceDataSource});

  @override
  DataSource<String> get dataSource => sourceDataSource.map(
        getMapper: (text) => base64.encode(text.codeUnits),
        setMapper: (encoded) => utf8.decode(base64.decode(encoded)),
      );
}
