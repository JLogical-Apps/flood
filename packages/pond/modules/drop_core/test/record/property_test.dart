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

    data.intProperty.set(0);
    expect(data.intProperty.value, 0);

    expect(() => data.state = State(data: {}), throwsA(isA<Exception>()));

    data.state = State(data: {'int': 1});
    expect(data.intProperty.value, 1);
  });

  test('fallback', () {
    final data = Data3();
    expect(data.intProperty.value, -1);
    expect(data.state.data, {});

    data.intProperty.set(0);
    expect(data.intProperty.value, 0);

    data.state = State(data: {});
    expect(data.intProperty.value, -1);

    data.state = State(data: {'int': 1});
    expect(data.intProperty.value, 1);
  });

  test('fallback replacement', () {
    final data = Data4();
    expect(data.intProperty.value, -1);
    expect(data.state.data, {'int': -1});

    data.intProperty.set(0);
    expect(data.intProperty.value, 0);

    data.state = State(data: {});
    expect(data.intProperty.value, -1);

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

class Data3 extends ValueObject {
  late final intProperty = field<int>(name: 'int').withFallback(() => -1);

  @override
  List<ValueObjectBehavior> get behaviors => [intProperty];
}

class Data4 extends ValueObject {
  late final intProperty = field<int>(name: 'int').withFallbackReplacement(() => -1);

  @override
  List<ValueObjectBehavior> get behaviors => [intProperty];
}
