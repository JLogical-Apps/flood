import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:test/test.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  late CorePondContext corePondContext;
  setUp(() async {
    corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(DropCoreComponent());
    await corePondContext.register(PortDropCoreComponent());
  });

  test('Port for basic ValueObject.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data1.new, name: 'Data1');

    final user = Data1();
    var userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByName(Data1.nameField), isA<PortField<String, String>>());

    var result = await userPort.submit();
    expect(result.data.nameProperty.value, '');

    user.nameProperty.set('Jill');
    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getByName(Data1.nameField), 'Jill');

    userPort.setValue(name: Data1.nameField, value: 'John Doe');

    result = await userPort.submit();
    expect(result.isValid, true);
    expect(result.data.nameProperty.value, 'John Doe');
  });

  test('Port for non-blank fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data2.new, name: 'Data2');

    final user = Data2();
    var userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByName(Data2.nameField), isA<PortField>());

    final invalidResult = await userPort.submit();
    expect(invalidResult.isValid, false);

    user.nameProperty.set('Jill');
    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getByName(Data2.nameField), 'Jill');

    userPort.setValue(name: Data2.nameField, value: 'John Doe');

    final result = await userPort.submit();
    expect(result.isValid, true);
    expect(result.data.nameProperty.value, 'John Doe');
  });

  test('Port for display name fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data3.new, name: 'Data3');

    final user = Data3();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByName(Data3.nameField).findDisplayNameOrNull(), 'Name');
  });

  test('Port for multiline fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data4.new, name: 'Data4');

    final user = Data4();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByName(Data4.nameField).findIsMultiline(), false);
    expect(userPort.getFieldByName(Data4.descriptionField).findIsMultiline(), true);
  });

  test('ValueObject field.', () async {
    corePondContext.locate<TypeCoreComponent>()
      ..register(Data5.new, name: 'Data5')
      ..registerAbstract<Person>(name: 'Person')
      ..register<Student>(Student.new, name: 'Student', parents: [Person])
      ..register<Teacher>(Teacher.new, name: 'Teacher', parents: [Person]);

    final user = Data5();
    var userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByName(Data5.personField).findStageFieldOrNull(), isNotNull);
    expect((userPort[Data5.personField] as StageValue).value, isNull);

    user.personProperty.set(Teacher());
    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(
      (userPort[Data5.personField] as StageValue).value,
      corePondContext.locate<TypeCoreComponent>().getRuntimeType<Teacher>(),
    );
    var result = await userPort.submit();
    expect(result.data.personProperty.value, isA<Teacher>());

    user.personProperty.set(Student());
    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(
      (userPort[Data5.personField] as StageValue).value,
      corePondContext.locate<TypeCoreComponent>().getRuntimeType<Student>(),
    );
    result = await userPort.submit();
    expect(result.isValid, false);

    (userPort[Data5.personField] as StageValue).port![Student.nameField] = 'John Doe';

    result = await userPort.submit();
    expect((result.data.personProperty.value as Student).nameProperty.value, 'John Doe');
  });

  test('Port for hint fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data6.new, name: 'Data6');

    final user = Data6();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByName(Data6.firstNameField).findHintOrNull(), 'John');
    expect(userPort.getFieldByName(Data6.lastNameField).findHintOrNull(), 'Doe');
    expect(userPort.getFieldByName(Data6.nameField).findHintOrNull(), 'John Doe');
    expect(userPort.getFieldByName(Data6.errorField).findHintOrNull(), isNull);

    userPort[Data6.firstNameField] = 'Jill';
    expect(userPort.getFieldByName(Data6.firstNameField).findHintOrNull(), 'John');
    expect(userPort.getFieldByName(Data6.nameField).findHintOrNull(), 'Jill Doe');
  });
}

class Data1 extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField);

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}

class Data2 extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).isNotBlank();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}

class Data3 extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}

class Data4 extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const descriptionField = 'description';
  late final descriptionProperty = field<String>(name: descriptionField).withDisplayName('Description').multiline();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty, descriptionProperty];
}

class Data5 extends ValueObject {
  static const personField = 'person';
  late final personProperty = field<Person>(name: personField).withDisplayName('Person');

  @override
  List<ValueObjectBehavior> get behaviors => [personProperty];
}

abstract class Person extends ValueObject {}

class Student extends Person {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).isNotBlank();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}

class Teacher extends Person {}

class Data6 extends ValueObject {
  static const firstNameField = 'firstName';
  late final firstNameProperty = field<String>(name: firstNameField).nullIfBlank().withPlaceholder(() => 'John');

  static const lastNameField = 'lastName';
  late final lastNameProperty = field<String>(name: lastNameField).nullIfBlank().withFallbackReplacement(() => 'Doe');

  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField)
      .nullIfBlank()
      .withFallback(() => '${firstNameProperty.value} ${lastNameProperty.value}');

  static const errorField = 'error';
  late final errorProperty = field<String>(name: errorField).withFallback(() => throw Exception('Error!'));

  @override
  List<ValueObjectBehavior> get behaviors => [firstNameProperty, lastNameProperty, nameProperty, errorProperty];
}
