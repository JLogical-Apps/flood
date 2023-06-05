import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('lifecycle methods', () async {
    var beforeInitialize = false;
    var afterInitialize = false;
    var beforeCreate = false;
    var afterCreate = false;
    var beforeSave = false;
    var afterSave = false;
    var beforeDelete = false;
    var afterDelete = false;

    final repository = Repository.memory().forType<TestEntity, TestData>(
      () => TestEntity(
        beforeInitializeGetter: () => beforeInitialize = true,
        afterInitializeGetter: () => afterInitialize = true,
        beforeCreateGetter: () => beforeCreate = true,
        afterCreateGetter: () => afterCreate = true,
        beforeSaveGetter: () => beforeSave = true,
        afterSaveGetter: () => afterSave = true,
        beforeDeleteGetter: () => beforeDelete = true,
        afterDeleteGetter: () => afterDelete = true,
      ),
      TestData.new,
      entityTypeName: 'TestEntity',
      valueObjectTypeName: 'TestData',
    );

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    final entity = TestEntity()..set(TestData());

    var updatedState = await repository.update(entity);

    expect(beforeInitialize, true);
    expect(afterInitialize, true);
    expect(beforeCreate, true);
    expect(afterCreate, true);
    expect(beforeSave, true);
    expect(afterSave, true);
    expect(beforeDelete, false);
    expect(afterDelete, false);
    expect(updatedState['counter'], 6);

    beforeInitialize = false;
    afterInitialize = false;
    beforeCreate = false;
    afterCreate = false;
    beforeSave = false;
    afterSave = false;

    updatedState = await repository.update(updatedState);

    expect(beforeInitialize, true);
    expect(afterInitialize, true);
    expect(beforeCreate, false);
    expect(afterCreate, false);
    expect(beforeSave, true);
    expect(afterSave, true);
    expect(beforeDelete, false);
    expect(afterDelete, false);
    expect(updatedState['counter'], 10);

    beforeInitialize = false;
    afterInitialize = false;
    beforeSave = false;
    afterSave = false;

    updatedState = await repository.delete(updatedState);

    // counter goes up for beforeInitialize, afterInitialize, beforeDelete
    expect(beforeInitialize, true);
    expect(afterInitialize, true);
    expect(beforeCreate, false);
    expect(afterCreate, false);
    expect(beforeSave, false);
    expect(afterSave, false);
    expect(beforeDelete, true);
    expect(afterDelete, true);
    expect(updatedState['counter'], 14);
  });
}

class TestData extends ValueObject {
  late final counterProperty = field<int>(name: 'counter').withFallbackReplacement(() => 0);

  @override
  List<ValueObjectBehavior> get behaviors => [counterProperty];
}

class TestEntity extends Entity<TestData> {
  final FutureOr Function()? beforeInitializeGetter;
  final FutureOr Function()? afterInitializeGetter;
  final FutureOr Function()? beforeCreateGetter;
  final FutureOr Function()? afterCreateGetter;
  final FutureOr Function()? beforeSaveGetter;
  final FutureOr Function()? afterSaveGetter;
  final FutureOr Function()? beforeDeleteGetter;
  final FutureOr Function()? afterDeleteGetter;

  TestEntity({
    this.beforeInitializeGetter,
    this.afterInitializeGetter,
    this.beforeCreateGetter,
    this.afterCreateGetter,
    this.beforeSaveGetter,
    this.afterSaveGetter,
    this.beforeDeleteGetter,
    this.afterDeleteGetter,
  });

  @override
  FutureOr<State?> onBeforeInitialize(DropCoreContext context, {required State state}) async {
    await beforeInitializeGetter?.call();
    return state.withData(state.data.copy()..update('counter', (counter) => counter + 1));
  }

  @override
  FutureOr onAfterInitalize(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await afterInitializeGetter?.call();
  }

  @override
  FutureOr onBeforeCreate(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await beforeCreateGetter?.call();
  }

  @override
  FutureOr onAfterCreate(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await afterCreateGetter?.call();
  }

  @override
  FutureOr onBeforeSave(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await beforeSaveGetter?.call();
  }

  @override
  FutureOr onAfterSave(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await afterSaveGetter?.call();
  }

  @override
  FutureOr onBeforeDelete(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await beforeDeleteGetter?.call();
  }

  @override
  FutureOr onAfterDelete(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await afterDeleteGetter?.call();
  }
}
