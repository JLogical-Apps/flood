import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  late CorePondContext context;
  late DropCoreContext dropContext;

  setUp(() {
    context = CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent());
    dropContext = context.locate<DropCoreComponent>();
  });

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
    dropContext.register<Data3>(Data3.new, name: 'Data3');

    final data = Data3();
    expect(data.intProperty.value, -1);
    expect(data.getState(dropContext).data, {});

    data.intProperty.set(0);
    expect(data.intProperty.value, 0);

    data.state = State(data: {});
    expect(data.intProperty.value, -1);

    data.state = State(data: {'int': 1});
    expect(data.intProperty.value, 1);
  });

  test('fallback replacement', () {
    dropContext.register<Data4>(Data4.new, name: 'Data4');

    final data = Data4();
    expect(data.intProperty.value, -1);
    expect(data.getState(dropContext).data, {'int': -1});

    data.intProperty.set(0);
    expect(data.intProperty.value, 0);

    data.state = State(data: {});
    expect(data.intProperty.value, -1);

    data.state = State(data: {'int': 1});
    expect(data.intProperty.value, 1);
  });

  test('placeholder', () {
    dropContext.register<Data5>(Data5.new, name: 'Data5');

    final data = Data5();
    expect(data.intProperty.value, -1);
    expect(data.getState(dropContext).data, {});

    data.intProperty.set(0);
    expect(data.intProperty.value, 0);

    data.state = State(data: {});
    expect(data.intProperty.value, -1);

    data.state = State(data: {'int': 1});
    expect(data.intProperty.value, 1);
  });

  test('not blank', () {
    dropContext.register<Data6>(Data6.new, name: 'Data6');

    final data = Data6();
    expect(() => data.nameProperty.value, throwsA(isA<Exception>()));

    data.nameProperty.set('John Doe');
    expect(data.nameProperty.value, 'John Doe');

    expect(() => data.state = State(data: {}), throwsA(isA<Exception>()));

    data.state = State(data: {'name': 'John Doe'});
    expect(data.nameProperty.value, 'John Doe');
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

class Data5 extends ValueObject {
  late final intProperty = field<int>(name: 'int').withPlaceholder(() => -1);

  @override
  List<ValueObjectBehavior> get behaviors => [intProperty];
}

class Data6 extends ValueObject {
  late final nameProperty = field<String>(name: 'name').isNotBlank();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}
