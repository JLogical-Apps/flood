import 'dart:convert';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/mappers/with_mapper_data_source.dart';
import 'package:jlogical_utils/src/utils/util.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

class YamlDataSourceMapper extends DataSource<Map<String, dynamic>>
    with WithMapperDataSource<String, Map<String, dynamic>> {
  final DataSource<String> parent;

  YamlDataSourceMapper({required this.parent});

  @override
  String saveMapped(Map<String, dynamic> obj) {
    return json2yaml(obj);
  }

  @override
  Map<String, dynamic>? loadMapped(String? obj) {
    return obj.mapIfNonNull((obj) => json.decode(json.encode(loadYaml(obj))));
  }
}
