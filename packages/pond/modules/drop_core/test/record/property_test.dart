import 'package:drop_core/drop_core.dart';
import 'package:test/test.dart';

void main() {
  test('properties', () {
    final data = Data1();
    expect(data.intProperty.value, null);

    data.intProperty.value = 0;
    expect(data.intProperty.value, 0);

    data.state = State(data: {});
    expect(data.intProperty.value, null);

    data.state = State(data: {'int': 1});
    expect(data.intProperty.value, 1);
  });

  test('required', () {
    final data = Data2();
    expect(() => data.intProperty.value, throwsA(isA<Exception>()));

    data.intProperty.value = 0;
    expect(data.intProperty.value, 0);

    expect(() => data.state = State(data: {}), throwsA(isA<Exception>()));

    data.state = State(data: {'int': 1});
    expect(data.intProperty.value, 1);
  });
}

class Data1 extends ValueObject {
  late final intProperty = field<int>(name: 'int');

  @override
  List<ValueObjectBehavior> get behaviors => [intProperty];
}

class Data2 extends ValueObject {
  late final intProperty = field<int>(name: 'int').required();

  @override
  List<ValueObjectBehavior> get behaviors => [intProperty];
}
