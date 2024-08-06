import 'package:utils_core/utils_core.dart';

class Namespace {
  final String name;
  final Map<String, String> fieldNameToField;

  const Namespace({required this.name, required this.fieldNameToField});

  String toTypescriptString() {
    return '''\
declare namespace $name {
${fieldNameToField.mapToIterable((fieldName, field) => "  const $fieldName: '$field';").join('\n')}
}''';
  }
}
