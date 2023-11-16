import 'package:drop_core/drop_core.dart';
import 'package:test/test.dart';
import 'package:runtime_type/type.dart';

void main() {
  test('persist state as json.', () {
    final typeContext = TypeContext();
    final myTypeRuntimeType = typeContext.register<MyType>(MyType.new, name: 'MyType');

    const id = '123';
    const type = 'MyType';

    final state = State(
      id: id,
      type: myTypeRuntimeType,
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
      StatePersister.jsonString(context: DropCoreContext(typeContext: typeContext)).persist(state),
      '''\
{
  "_id": "$id",
  "_type": "$type",
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
  }
}''',
    );
  });
}

class MyType {}
