import 'dart:convert';

import 'package:persistence_core/persistence_core.dart';

class JsonDataSource with IsDataSourceWrapper<Map<String, dynamic>> {
  final DataSource<String> sourceDataSource;

  JsonDataSource({required this.sourceDataSource});

  @override
  DataSource<Map<String, dynamic>> get dataSource => sourceDataSource.map(
        getMapper: (text) => json.decode(text),
        setMapper: (jsonObject) => JsonEncoder.withIndent(' ' * 2).convert(jsonObject),
      );
}
