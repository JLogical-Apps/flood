import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/state/persistence/json_state_persister.dart';
import 'package:test/test.dart';

void main() {
  test('persist state as json.', () {
    const id = '123';
    const type = 'MyType';

    final state = State(
      id: id,
      type: type,
      data: {
        'number': 1,
        'string': 'hello world',
        'bool': true,
        'list': [
          1,
          2,
          3,
        ],
        'map': {'key': 'value'},
        'embedded': State(
          data: {'embeddedKey': 'embeddedValue'},
        ),
      },
    );

    expect(
      JsonStatePersister().persist(state),
      '''\
{
  "number": 1,
  "string": "hello world",
  "bool": true,
  "list": [
    1,
    2,
    3
  ],
  "map": {
    "key": "value"
  },
  "embedded": {
    "embeddedKey": "embeddedValue"
  },
  "_id": "$id",
  "_type": "$type"
}''',
    );
  });
}
