import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:runtime_type/type.dart';
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

  test('serialize ValueObject', () {
    final data = Data();

    dropContext.register<Data>(Data.new, name: 'Data');

    expect(
        data.getState(dropContext),
        State(
          type: dropContext.getRuntimeType<Data>(),
          data: {
            'int': null,
            'bool': null,
            'string': null,
          },
        ));

    data.intProperty.value = 1;
    data.boolProperty.value = true;
    data.stringProperty.value = 'hello world';

    expect(
        data.getState(dropContext),
        State(
          type: dropContext.getRuntimeType<Data>(),
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
