import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:runtime_type/type.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

const nameFallback = 'John Doe';

void main() {
  late CorePondContext context;
  late DropCoreContext dropContext;

  setUp(() {
    context = CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent());
    dropContext = context.locate<DropCoreComponent>();
  });

  test('async fallback', () async {
    dropContext.register<Data1>(Data1.new, name: 'Data1');

    final repository = Repository.forType<Data1Entity, Data1>(
      Data1Entity.new,
      Data1.new,
      entityTypeName: 'Data1Entity',
      valueObjectTypeName: 'Data1',
    ).memory();

    await context.register(repository);

    final data = Data1();
    expect(data.nameProperty.value, isNull);

    data.nameProperty.set('Bob');
    expect(data.nameProperty.value, 'Bob');

    data.nameProperty.set(null);

    final dataEntity = await repository.updateEntity(Data1Entity()..set(data));
    expect(dataEntity.value.nameProperty.value, nameFallback);

    var retrievedDataEntity = await repository.executeQuery(Query.getById<Data1Entity>(dataEntity.id!));
    expect(retrievedDataEntity.value.nameProperty.value, nameFallback);

    // Add empty Data to test retrieval fallback.
    final state = await repository.update(State(
      type: dropContext.getRuntimeType<Data1Entity>(),
      data: {},
    ));
    retrievedDataEntity = await repository.executeQuery(Query.getById<Data1Entity>(state.id!));
    expect(retrievedDataEntity.value.nameProperty.value, nameFallback);
  });
}

class Data1 extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withAsyncFallback((context) async {
    await Future(() {});
    return nameFallback;
  });

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}

class Data1Entity extends Entity<Data1> {}
