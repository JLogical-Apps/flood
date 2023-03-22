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
