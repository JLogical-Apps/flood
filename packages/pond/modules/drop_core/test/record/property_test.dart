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

  test('required', () async {
    final data = Data2();
    expect(() => data.intProperty.value, throwsA(isA<Exception>()));

    data.intProperty.set(0);
    expect(data.intProperty.value, 0);

    data.state = State(data: {});
    expect(await data.validate(null), isNotNull);

    data.state = State(data: {'int': 1});
    expect(data.intProperty.value, 1);
  });

  test('fallback', () {
    dropContext.register<Data3>(Data3.new, name: 'Data3');

    final data = Data3();
    expect(data.intProperty.value, -1);
    expect(data.getState(dropContext).data, {'int': -1});

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
    expect(data.getState(dropContext).data, {'int': -1});

    data.intProperty.set(0);
    expect(data.intProperty.value, 0);

    data.state = State(data: {});
    expect(data.intProperty.value, -1);

    data.state = State(data: {'int': 1});
    expect(data.intProperty.value, 1);
  });

  test('not blank', () async {
    dropContext.register<Data6>(Data6.new, name: 'Data6');

    final data = Data6();
    expect(() => data.nameProperty.value, throwsA(isA<Exception>()));

    data.nameProperty.set('John Doe');
    expect(data.nameProperty.value, 'John Doe');

    data.state = State(data: {});
    expect(await data.validate(null), isNotNull);

    data.state = State(data: {'name': 'John Doe'});
    expect(data.nameProperty.value, 'John Doe');
  });

  test('list', () {
    dropContext.register<Data7>(Data7.new, name: 'Data7');

    final data = Data7();
    expect(data.itemsProperty.value, []);

    data.itemsProperty.set(['one', 'two', 'three']);
    expect(data.itemsProperty.value, ['one', 'two', 'three']);

    data.state = State(data: {});
    expect(data.itemsProperty.value, []);

    data.state = State(data: {
      'items': ['hello', 'world'],
    });
    expect(data.itemsProperty.value, ['hello', 'world']);
  });

  test('computed', () {
    dropContext.register<Data8>(Data8.new, name: 'Data8');

    final data = Data8()
      ..firstNameProperty.set('John')
      ..lastNameProperty.set('Doe');

    expect(data.nameProperty.value, 'John Doe');
    expect(data.getState(dropContext).data, {
      'firstName': 'John',
      'lastName': 'Doe',
      'name': 'John Doe',
    });
  });

  test('map', () {
    dropContext.register<Data9>(Data9.new, name: 'Data9');

    final data = Data9();
    expect(data.studentToScoreProperty.value, {});

    data.studentToScoreProperty.set({'Jack': 82, 'Jill': 93});
    expect(data.studentToScoreProperty.value, {'Jack': 82, 'Jill': 93});

    data.state = State(data: {});
    expect(data.studentToScoreProperty.value, {});

    data.state = State(data: {
      'studentToScore': {'Jack': 82, 'Jill': 93},
    });
    expect(data.studentToScoreProperty.value, {'Jack': 82, 'Jill': 93});
  });

  test('timestamp', () {
    dropContext.register<Data10>(Data10.new, name: 'Data10');

    final data = Data10()..dateProperty.set(Timestamp.now());
    expect(data.dateProperty.value?.time.isBefore(DateTime.now().add(Duration(milliseconds: 1))), isTrue);

    data.dateProperty.set(Timestamp.of(DateTime.now().add(Duration(days: 1))));
    expect(data.dateProperty.value?.time.isAfter(DateTime.now()), isTrue);
  });

  test('property with validation', () async {
    dropContext.register<Data11>(Data11.new, name: 'Data11');

    final data = Data11();
    expect(await data.validate(null), isNotNull);

    data.amountProperty.set(-12);
    data.emailProperty.set('asdf');
    expect(await data.validate(null), isNotNull);

    data.amountProperty.set(12);
    data.emailProperty.set('asdf');
    expect(await data.validate(null), isNotNull);

    data.amountProperty.set(-12);
    data.emailProperty.set('test@test.com');
    expect(await data.validate(null), isNotNull);

    data.amountProperty.set(12);
    data.emailProperty.set('test@test.com');
    expect(await data.validate(null), isNull);
  });

  test('email property', () async {
    dropContext.register<Data12>(Data12.new, name: 'Data12');

    final data = Data12();
    expect(await data.validate(null), isNotNull);

    data.emailProperty.set('asdf');
    expect(await data.validate(null), isNotNull);

    data.emailProperty.set('test@test.com');
    expect(await data.validate(null), isNull);
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

class Data7 extends ValueObject {
  late final itemsProperty = field<String>(name: 'items').list();

  @override
  List<ValueObjectBehavior> get behaviors => [itemsProperty];
}

class Data8 extends ValueObject {
  late final firstNameProperty = field<String>(name: 'firstName').isNotBlank();
  late final lastNameProperty = field<String>(name: 'lastName').isNotBlank();
  late final nameProperty = computed<String>(
    name: 'name',
    computation: () => '${firstNameProperty.value} ${lastNameProperty.value}',
  );

  @override
  List<ValueObjectBehavior> get behaviors => [firstNameProperty, lastNameProperty, nameProperty];
}

class Data9 extends ValueObject {
  late final studentToScoreProperty = field<String>(name: 'studentToScore').mapTo<int>();

  @override
  List<ValueObjectBehavior> get behaviors => [studentToScoreProperty];
}

class Data10 extends ValueObject {
  late final dateProperty = field<Timestamp>(name: 'date');

  @override
  List<ValueObjectBehavior> get behaviors => [dateProperty];
}

class Data11 extends ValueObject {
  late final amountProperty = field<int>(name: 'amount').required().withValidator(Validator.isPositive().cast<int>());
  late final emailProperty = field<String>(name: 'email').required().withValidator(Validator.isEmail().cast<String>());

  @override
  List<ValueObjectBehavior> get behaviors => [amountProperty, emailProperty];
}

class Data12 extends ValueObject {
  late final emailProperty = field<String>(name: 'email').isEmail().isNotBlank();

  @override
  List<ValueObjectBehavior> get behaviors => [emailProperty];
}
