import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  setUp(() {
    AppContext.global = AppContext.createForTesting();
  });

  test('new user port', () async {
    const name = 'John Doe';
    const email = 'a@b.com';
    const male = 'm';
    const isArchived = false;

    final user = User();
    final port = user.toPort();
    port[user.nameProperty.name] = name;
    port[user.emailProperty.name] = email;
    port[user.genderProperty.name] = male;
    port[user.isArchivedProperty.name] = isArchived;

    final result = await port.submit();
    final portUser = result.result!;

    expect(portUser.nameProperty.value, name);
    expect(portUser.emailProperty.value, email);
    expect(portUser.genderProperty.value, male);
    expect(portUser.isArchivedProperty.value, isArchived);
  });

  test('existing user port', () async {
    const name = 'John Doe';
    const newName = 'Jack Brown';
    const email = 'a@b.com';
    const male = 'm';

    final user = User()
      ..nameProperty.value = name
      ..emailProperty.value = email
      ..genderProperty.value = male;
    final port = user.toPort();
    port[user.nameProperty.name] = newName;

    final result = await port.submit();
    final portUser = result.result!;

    expect(portUser.nameProperty.value, newName);
    expect(portUser.emailProperty.value, email);
    expect(portUser.genderProperty.value, male);
    expect(portUser.isArchivedProperty.value, false);
  });

  test('validation of user port', () async {
    const empty = '';
    const name = 'John Doe';
    const email = 'a@b.com';
    const male = 'm';

    final user = User();
    final port = user.toPort();
    port[user.nameProperty.name] = name;
    port[user.emailProperty.name] = email;
    port[user.genderProperty.name] = male;
    final validResult = await port.submit();
    expect(validResult.isValid, isTrue);

    port[user.emailProperty.name] = empty;
    final emptyEmailResult = await port.submit();
    expect(emptyEmailResult.isValid, isFalse);

    port[user.emailProperty.name] = email;
    port[user.genderProperty.name] = empty;
    final emptyGenderResult = await port.submit();
    expect(emptyGenderResult.isValid, isFalse);
  });

  test('embedded ports', () async {
    AppContext.global = AppContext.createForTesting()
      ..register(SimpleAppModule(valueObjectRegistrations: [ValueObjectRegistration<User, User?>(() => User())]));

    const name = 'John Doe';
    const email = 'a@b.com';
    const male = 'm';
    const newEmail = 'b@a.com';

    const projectName = 'Project';
    const newProjectName = 'Project 2';

    final project = Project()
      ..nameProperty.value = projectName
      ..userProperty.value = (User()
        ..nameProperty.value = name
        ..emailProperty.value = email
        ..genderProperty.value = male);
    final port = project.toPort();
    port[project.nameProperty.name] = newProjectName;
    port[project.userProperty.name]['email'] = newEmail;

    final result = await port.submit();
    final projectResult = result.result!;

    expect(projectResult.nameProperty.value, newProjectName);
    expect(
        projectResult.userProperty.value,
        User()
          ..nameProperty.value = name
          ..emailProperty.value = newEmail
          ..genderProperty.value = male
          ..isArchivedProperty.value = false);
  });
}

class User extends ValueObject with WithPortGenerator<User> {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final emailProperty = FieldProperty<String>(name: 'email').required();
  late final genderProperty = FieldProperty<String>(name: 'gender').required();
  late final isArchivedProperty = FieldProperty<bool>(name: 'isArchived').withFallback(() => false);

  @override
  List<Property> get properties => super.properties + [nameProperty, emailProperty, genderProperty, isArchivedProperty];

  @override
  List<PortField> get portFields => [
        nameProperty.toPortField().required(),
        emailProperty.toPortField().isEmail().required(),
        genderProperty.toOptionsPortField(['m', 'f']).required(),
        isArchivedProperty.toPortField(),
      ];
}

class Project extends ValueObject with WithPortGenerator<Project> {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final userProperty = FieldProperty<User>(name: 'user').required();

  @override
  List<Property> get properties => super.properties + [nameProperty, userProperty];

  @override
  List<PortField> get portFields => [
        nameProperty.toPortField().required(),
        userProperty.toEmbeddedPortField((user) => (user ?? User()).toPort()).required(),
      ];
}
