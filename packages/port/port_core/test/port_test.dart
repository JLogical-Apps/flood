import 'package:port_core/port_core.dart';
import 'package:test/test.dart';

void main() {
  test('basic port', () async {
    const name = 'John Doe';

    final port = Port.of({
      'name': PortField.string(),
    });

    expect(port['name'], '');

    port.setValue(name: 'name', value: name);

    expect(port['name'], name);

    final result = await port.submit();

    expect(result.isValid, true);
    expect(result.data['name'], name);
  });

  test('basic port validation', () async {
    const name = 'John Doe';
    const email = 'doe@mail.com';

    final port = Port.of({
      'name': PortField.string().isNotBlank(),
      'email': PortField.string().isNotBlank().isEmail(),
    });

    expect(port['name'], '');
    expect(port['email'], '');

    var result = await port.submit();
    expect(result.isValid, false);
    expect(port.getErrorByName('name'), isNotNull);
    expect(port.getErrorByName('email'), isNotNull);

    port.setValue(name: 'name', value: name);
    port.setValue(name: 'email', value: 'invalidEmail');

    result = await port.submit();
    expect(result.isValid, false);
    expect(port.getErrorByName('name'), isNull);
    expect(port.getErrorByName('email'), isNotNull);

    port.setValue(name: 'email', value: email);

    result = await port.submit();
    expect(result.isValid, true);
    expect(result.data['name'], name);
    expect(result.data['email'], email);
  });

  test('embedded port', () async {
    final contactPort = Port.of({
      'phone': PortField.string(),
      'email': PortField.string().isNotBlank().isEmail(),
    });
    final port = Port.of({
      'contact': PortField.port(port: contactPort),
    });

    expect(port['contact'] as Port, contactPort);

    var result = await port.submit();
    expect(result.isValid, false);

    contactPort['email'] = 'test@test.com';

    result = await port.submit();
    final contactResult = result.data['contact'] as Map<String, dynamic>;

    expect(contactResult['phone'], '');
    expect(contactResult['email'], 'test@test.com');
  });

  test('options of field', () {
    final contactPort = Port.of({
      'phone': PortField.string().withDisplayName('Phone'),
      'email': PortField.string().withDisplayName('Email').isNotBlank().isEmail(),
      'gender': PortField.option(initialValue: 'M', options: ['M', 'F']).withDisplayName('Gender'),
    });

    expect(contactPort.getFieldByName('phone').findOptionsOrNull(), null);
    expect(contactPort.getFieldByName('email').findOptionsOrNull(), null);
    expect(contactPort.getFieldByName('gender').findOptionsOrNull(), ['M', 'F']);
  });

  test('display name of field', () {
    final contactPort = Port.of({
      'phone': PortField.string().withDisplayName('Phone'),
      'email': PortField.string().withDisplayName('Email').isNotBlank().isEmail(),
      'gender': PortField.option(initialValue: 'M', options: ['M', 'F']).withDisplayName('Gender'),
    });

    expect(contactPort.getFieldByName('phone').findDisplayNameOrNull(), 'Phone');
    expect(contactPort.getFieldByName('email').findDisplayNameOrNull(), 'Email');
    expect(contactPort.getFieldByName('gender').findDisplayNameOrNull(), 'Gender');
  });

  test('multiline fields', () {
    final contactPort = Port.of({
      'name': PortField.string().withDisplayName('Name').isNotBlank(),
      'notes': PortField.string().withDisplayName('Description').multiline(),
    });

    expect(contactPort.getFieldByName('name').findIsMultiline(), false);
    expect(contactPort.getFieldByName('notes').findIsMultiline(), true);
  });

  test('interface fields', () async {
    final portByType = <Type, Port<Person>>{
      Student: Port.of({'name': PortField.string().isNotBlank()}).map((value, port) => Student(name: value['name'])),
      Teacher: Port.of({'name': PortField.string().isNotBlank()}).map((value, port) => Teacher(name: value['name'])),
    };

    final personPort = Port.of({
      'person': PortField.stage<Type, Person>(
        initialValue: Student,
        portMapper: (value) => portByType[value]!,
        options: [Student, Teacher],
      ),
    });

    var result = await personPort.submit();
    expect(result.isValid, false);

    final personField = personPort.getFieldByName('person') as StagePortField<Type, Person>;
    expect(personField.findStageFieldOrNull(), isA<StagePortField<Type, Person>>());

    final stageValue = personField.value;
    stageValue.port!['name'] = 'John Doe';
    result = await personPort.submit();
    expect((result.data['person'] as Student).name, 'John Doe');

    personPort['person'] = personField.getStageValue(Teacher);
  });
}

abstract class Person {
  final String name;

  Person({required this.name});
}

class Teacher extends Person {
  Teacher({required super.name});
}

class Student extends Person {
  Student({required super.name});
}
