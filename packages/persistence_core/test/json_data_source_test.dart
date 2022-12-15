import 'package:persistence_core/persistence_core.dart';
import 'package:test/test.dart';

void main() {
  test('json get', () async {
    final stringDataSource = DataSource.memory<String>(
      initialData: '''\
{
  "int": 3,
  "string": "Hello World!",
  "bool": true,
  "list": [
    1,
    2
  ],
  "map": {
    "key1": "value1",
    "key2": "value2"
  }
}''',
    );
    final jsonDataSource = stringDataSource.mapJson();
    final json = await jsonDataSource.get();

    expect(json['int'], 3);
    expect(json['string'], 'Hello World!');
    expect(json['bool'], true);
    expect(json['list'], [1, 2]);
    expect(json['map'], {'key1': 'value1', 'key2': 'value2'});
  });

  test('json set', () async {
    final stringDataSource = DataSource.memory<String>(initialData: '');
    final jsonDataSource = stringDataSource.mapJson();

    final json = {
      'int': 3,
      'string': 'Hello World!',
      'bool': true,
      'list': [1, 2],
      'map': {
        'key1': 'value1',
        'key2': 'value2',
      },
    };

    await jsonDataSource.set(json);

    final string = await stringDataSource.get();

    expect(
      string,
      '''\
{
  "int": 3,
  "string": "Hello World!",
  "bool": true,
  "list": [
    1,
    2
  ],
  "map": {
    "key1": "value1",
    "key2": "value2"
  }
}''',
    );
  });
}
