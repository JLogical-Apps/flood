import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:test/test.dart';

void main() {
  test('serialize ValueObject', () {
    final data = Data();

    expect(
        data.state,
        State(
          type: '$Data',
          data: {},
        ));

    data.intProperty.value = 1;
    data.boolProperty.value = true;
    data.stringProperty.value = 'hello world';

    expect(
        data.state,
        State(
          type: '$Data',
          data: {
            'int': 1,
            'bool': true,
            'string': 'hello world',
          },
        ));
  });
}

class Data extends ValueObject {
  late final intProperty = field<int>(name: 'int');
  late final boolProperty = field<bool>(name: 'bool');
  late final stringProperty = field<String>(name: 'string');

  @override
  List<ValueObjectBehavior> get behaviors => [intProperty, boolProperty, stringProperty];
}
