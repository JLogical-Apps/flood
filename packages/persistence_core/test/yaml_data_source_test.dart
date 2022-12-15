import 'package:persistence_core/persistence_core.dart';
import 'package:test/test.dart';

void main() {
  test('yaml get', () async {
    final stringDataSource = DataSource.memory<String>(
      initialData: ''
          'int: 3\n'
          'string: Hello World!\n'
          'bool: true\n'
          'list:\n'
          '  - 1\n'
          '  - 2\n'
          'map:\n'
          '  key1: value1\n'
          '  key2: value2\n',
    );
    final yamlDataSource = stringDataSource.mapYaml();
    final yaml = await yamlDataSource.get();

    expect(yaml['int'], 3);
    expect(yaml['string'], 'Hello World!');
    expect(yaml['bool'], true);
    expect(yaml['list'], [1, 2]);
    expect(yaml['map'], {'key1': 'value1', 'key2': 'value2'});
  });

  test('yaml set', () async {
    final stringDataSource = DataSource.memory<String>(initialData: '');
    final yamlDataSource = stringDataSource.mapYaml();

    final yaml = {
      'int': 3,
      'string': 'Hello World!',
      'bool': true,
      'list': [1, 2],
      'map': {
        'key1': 'value1',
        'key2': 'value2',
      },
    };

    await yamlDataSource.set(yaml);

    final string = await stringDataSource.get();

    expect(
      string,
      'int: 3\n'
      'string: "Hello World!"\n'
      'bool: true\n'
      'list:\n'
      '  - 1\n'
      '  - 2\n'
      'map:\n'
      '  key1: value1\n'
      '  key2: value2\n',
    );
  });
}
