import 'dart:typed_data';

import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:runtime_type/type.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  late CorePondContext corePondContext;
  setUp(() async {
    corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(DropCoreComponent());
    await corePondContext.register(AssetCoreComponent(assetProviders: (_) => []));
    await corePondContext.register(PortDropCoreComponent());
  });

  test('Port for basic ValueObject.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data1.new, name: 'Data1');

    final user = Data1();
    var userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByPath(Data1.nameField), isA<PortField<String, String>>());

    var result = await userPort.submit();
    expect(result.data.nameProperty.value, '');

    user.nameProperty.set('Jill');
    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getByPath(Data1.nameField), 'Jill');

    userPort.setValue(path: Data1.nameField, value: 'John Doe');

    result = await userPort.submit();
    expect(result.isValid, true);
    expect(result.data.nameProperty.value, 'John Doe');
  });

  test('Port for non-blank fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data2.new, name: 'Data2');

    final user = Data2();
    var userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByPath(Data2.nameField), isA<PortField>());

    final invalidResult = await userPort.submit();
    expect(invalidResult.isValid, false);

    user.nameProperty.set('Jill');
    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getByPath(Data2.nameField), 'Jill');

    userPort.setValue(path: Data2.nameField, value: 'John Doe');

    final result = await userPort.submit();
    expect(result.isValid, true);
    expect(result.data.nameProperty.value, 'John Doe');
  });

  test('Port for display name fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data3.new, name: 'Data3');

    final user = Data3();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByPath(Data3.nameField).findDisplayNameOrNull(), 'Name');
  });

  test('Port for multiline fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data4.new, name: 'Data4');

    final user = Data4();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByPath(Data4.nameField).findIsMultiline(), false);
    expect(userPort.getFieldByPath(Data4.descriptionField).findIsMultiline(), true);
  });

  test('Concrete ValueObject field.', () async {
    corePondContext.locate<TypeCoreComponent>()
      ..register(Data13.new, name: 'Data13')
      ..register<Student>(Student.new, name: 'Student');

    final user = Data13();
    var userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByPath(Data13.studentField).findStageFieldOrNull(), isNull);
    expect((userPort[Data13.studentField] as Port)[Student.nameField], isEmpty);

    user.studentProperty.set(Student());
    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByPath(Data13.studentField).findStageFieldOrNull(), isNull);
    expect((userPort[Data13.studentField] as Port)[Student.nameField], isEmpty);

    var result = await userPort.submit();
    expect(result.isValid, false);

    user.studentProperty.set(Student()..nameProperty.set('John Doe'));
    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);

    expect((userPort[Data13.studentField] as Port)[Student.nameField], 'John Doe');

    result = await userPort.submit();
    expect(result.isValid, true);
    expect(result.data.studentProperty.value, Student()..nameProperty.set('John Doe'));
  });

  test('Abstract ValueObject field.', () async {
    corePondContext.locate<TypeCoreComponent>()
      ..register(Data5.new, name: 'Data5')
      ..registerAbstract<Person>(name: 'Person')
      ..register<Student>(Student.new, name: 'Student', parents: [Person])
      ..register<Teacher>(Teacher.new, name: 'Teacher', parents: [Person]);

    final user = Data5();
    var userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByPath(Data5.personField).findStageFieldOrNull(), isNotNull);
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
    expect(userPort.getFieldByPath(Data6.firstNameField).findHintOrNull(), 'John');
    expect(userPort.getFieldByPath(Data6.lastNameField).findHintOrNull(), 'Doe');
    expect(userPort.getFieldByPath(Data6.nameField).findHintOrNull(), 'John Doe');
    expect(userPort.getFieldByPath(Data6.errorField).findHintOrNull(), isNull);

    userPort[Data6.firstNameField] = 'Jill';
    expect(userPort.getFieldByPath(Data6.firstNameField).findHintOrNull(), 'John');
    expect(userPort.getFieldByPath(Data6.nameField).findHintOrNull(), 'Jill Doe');
  });

  test('Port for default fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data7.new, name: 'Data7');

    final user = Data7();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(userPort.getFieldByPath(Data7.nameField).value, 'John');

    userPort[Data7.nameField] = 'Jill';
    expect(userPort.getFieldByPath(Data7.nameField).value, 'Jill');
  });

  test('Port with overridden fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data8.new, name: 'Data8');

    final user = Data8();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(
      user,
      overrides: [
        PortGeneratorOverride.update(
          Data8.firstNameField,
          portFieldUpdater: (portField) => portField.cast<String, String>().isNotBlank(),
        ),
        PortGeneratorOverride.override(
          Data8.lastNameField,
          portField: PortField.string(initialValue: 'Doe'),
        ),
        PortGeneratorOverride.remove(Data8.errorField),
      ],
    );

    expect((await userPort.submit()).isValid, false);
    userPort[Data8.firstNameField] = 'John';
    expect((await userPort.submit()).isValid, true);

    expect(userPort[Data8.lastNameField], 'Doe');
    expect(userPort.getFieldByPathOrNull(Data8.errorField), isNull);
  });

  test('Port for date fields.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data9.new, name: 'Data9');

    final user = Data9();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    expect(
      userPort.getFieldByPath(Data9.dateField).findDateFieldOrNull(),
      isA<DatePortField>().having((f) => f.isDate, 'isDate', true).having((f) => f.isTime, 'isTime', false),
    );
    expect(
      userPort.getFieldByPath(Data9.createdField).findDateFieldOrNull(),
      isA<DatePortField>().having((f) => f.isDate, 'isDate', true).having((f) => f.isTime, 'isTime', true),
    );
  });

  test('Port for email field.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data10.new, name: 'Data10');

    final user = Data10();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);

    var result = await userPort.submit();
    expect(result.isValid, isFalse);

    userPort[Data10.emailField] = 'asdf';
    result = await userPort.submit();
    expect(result.isValid, isFalse);

    userPort[Data10.emailField] = 'asdf@asdf.com';
    result = await userPort.submit();
    expect(result.isValid, isTrue);
  });

  test('Port for validator field.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data11.new, name: 'Data11');

    final user = Data11();
    final userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);

    var result = await userPort.submit();
    expect(result.isValid, isTrue);

    userPort[Data11.numberField] = -10;
    result = await userPort.submit();
    expect(result.isValid, isFalse);

    userPort[Data11.numberField] = 10;
    result = await userPort.submit();
    expect(result.isValid, isTrue);
  });

  test('Port for required hidden field.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data12.new, name: 'Data12');

    final user = Data12();
    var userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);

    expect(() => userPort.submit(), throwsA(anything));

    await Future(() {});

    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user, validateResult: false);
    expect(() => userPort.submit(), returnsNormally);

    await Future(() {});

    user.requiredProperty.set('Something not null');
    userPort = corePondContext.locate<PortDropCoreComponent>().generatePort(user);
    final result = await userPort.submit();
    expect(result.isValid, isTrue);
  });

  test('Port for asset field.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data14.new, name: 'Data14');

    final data = Data14();
    var dataPort = corePondContext.locate<PortDropCoreComponent>().generatePort(data);

    expect(dataPort.getFieldByPath('asset'), isA<PortField<AssetPortValue, AssetReferenceGetter?>>());
    expect((await dataPort.submit()).data.assetProperty.value, isNull);

    final assetValue = Uint8List.fromList([1, 2, 3]);

    dataPort['asset'] = (dataPort['asset'] as AssetPortValue)
        .withUpload(Asset.upload(path: 'image.png', value: assetValue, mimeType: 'image/png'));
    expect((await dataPort.submit()).data.assetProperty.value, isA<AssetReferenceGetter>());

    data.assetProperty.set(AssetReferenceGetter(
      id: 'someId',
      assetProviderGetter: (context) => AssetProvider.static.memory,
    ));
    dataPort = corePondContext.locate<PortDropCoreComponent>().generatePort(data);

    expect((await dataPort.submit()).data.assetProperty.value, isA<AssetReferenceGetter>());

    dataPort['asset'] = (dataPort['asset'] as AssetPortValue).withRemoved();
    expect((await dataPort.submit()).data.assetProperty.value, isNull);
  });

  test('Port for required asset field.', () async {
    corePondContext.locate<TypeCoreComponent>().register(Data15.new, name: 'Data15');

    final data = Data15();
    final dataPort = corePondContext.locate<PortDropCoreComponent>().generatePort(data);

    expect((await dataPort.submit()).isValid, isFalse);

    final assetValue = Uint8List.fromList([1, 2, 3]);

    dataPort['asset'] = (dataPort['asset'] as AssetPortValue)
        .withUpload(Asset.upload(path: 'image.png', value: assetValue, mimeType: 'image/png'));
    expect((await dataPort.submit()).data.assetProperty.value, isA<AssetReferenceGetter>());
  });

  test('Port for duplicated ValueObject with asset field.', () async {
    final assetProvider = AssetProvider.static.memory;
    corePondContext.locate<TypeCoreComponent>().register(() => Data15(assetProvider: assetProvider), name: 'Data15');

    final asset = Asset.upload(path: 'abc.png', value: Uint8List.fromList([]), mimeType: 'image/png');
    await assetProvider.upload(asset);

    final data = Data15(assetProvider: assetProvider)
      ..assetProperty.set(AssetReferenceGetter(
        id: asset.id,
        assetProviderGetter: (context) => assetProvider,
      ));
    final duplicate = Data15(assetProvider: assetProvider);
    await duplicate.duplicateFrom(corePondContext.dropCoreComponent, data);

    final sourcePort = corePondContext.locate<PortDropCoreComponent>().generatePort(data);
    final duplicatePort = corePondContext.locate<PortDropCoreComponent>().generatePort(duplicate);

    expect(
        sourcePort.getFieldByPath(Data15.assetField).findAssetFieldOrNull()!.value,
        isA<AssetPortValue>()
            .having((assetPortValue) => assetPortValue.initialValue, 'initialValue', isNotNull)
            .having((assetPortValue) => assetPortValue.uploadedAsset, 'uploadedAsset', isNull));

    expect(
        duplicatePort.getFieldByPath(Data15.assetField).findAssetFieldOrNull()!.value,
        isA<AssetPortValue>()
            .having((assetPortValue) => assetPortValue.initialValue, 'initialValue', isNull)
            .having((assetPortValue) => assetPortValue.uploadedAsset, 'uploadedAsset', isNotNull));

    final duplicateResult = await duplicatePort.submit();

    final oldAsset = await assetProvider.getById(asset.id).loadAsset();
    expect(oldAsset, isNotNull);

    final newAsset = await assetProvider.getById(duplicateResult.data.assetProperty.value.id).loadAsset();
    expect(newAsset, isNotNull);
    expect(newAsset, isNot(oldAsset));
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
  late final personProperty = field<Person>(name: personField).embedded().withDisplayName('Person');

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

class Data7 extends ValueObject {
  static const nameField = 'person';
  late final nameProperty = field<String>(name: nameField).withDefault(() => 'John');

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}

class Data8 extends ValueObject {
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

class Data9 extends ValueObject {
  static const dateField = 'date';
  late final dateProperty = field<Timestamp>(name: dateField).time().onlyDate().required();

  static const createdField = 'created';
  late final createdProperty = field<Timestamp>(name: createdField).time();

  @override
  List<ValueObjectBehavior> get behaviors => [dateProperty, createdProperty];
}

class Data10 extends ValueObject {
  static const emailField = 'email';
  late final emailProperty = field<String>(name: emailField).withDisplayName('Paypal Email').isEmail().isNotBlank();

  @override
  List<ValueObjectBehavior> get behaviors => [emailProperty];
}

class Data11 extends ValueObject {
  static const numberField = 'number';
  late final numberProperty = field<int>(name: numberField).isPositive();

  @override
  List<ValueObjectBehavior> get behaviors => [numberProperty];
}

class Data12 extends ValueObject {
  static const requiredField = 'required';
  late final requiredProperty = field<String>(name: requiredField).hidden().required();

  @override
  List<ValueObjectBehavior> get behaviors => [requiredProperty];
}

class Data13 extends ValueObject {
  static const studentField = 'student';
  late final studentProperty = field<Student>(name: studentField).embedded().required().withDisplayName('Student');

  @override
  List<ValueObjectBehavior> get behaviors => [studentProperty];
}

class Data14 extends ValueObject {
  static const assetField = 'asset';
  late final assetProperty =
      field<String>(name: assetField).asset(assetProvider: (context) => AssetProvider.static.memory);

  @override
  List<ValueObjectBehavior> get behaviors => [assetProperty];
}

class Data15 extends ValueObject {
  final AssetProvider assetProvider;

  Data15({AssetProvider? assetProvider}) : assetProvider = assetProvider ?? AssetProvider.static.memory;

  static const assetField = 'asset';
  late final assetProperty =
      field<String>(name: assetField).asset(assetProvider: (context) => assetProvider).required();

  @override
  List<ValueObjectBehavior> get behaviors => [assetProperty];
}
