import 'dart:convert';

import 'package:json2yaml/json2yaml.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:yaml/yaml.dart';

class YamlDataSource with IsDataSourceWrapper<Map<String, dynamic>> {
  final DataSource<String> sourceDataSource;

  YamlDataSource({required this.sourceDataSource});

  @override
  DataSource<Map<String, dynamic>> get dataSource => sourceDataSource.map(
        getMapper: (text) => json.decode(json.encode(loadYaml(text))),
        setMapper: (yaml) => json2yaml(yaml),
      );
}
