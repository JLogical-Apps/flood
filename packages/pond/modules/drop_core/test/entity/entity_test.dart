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

    final repository = Repository.forType<TestEntity, TestData>(
      () => TestEntity(
        beforeInitializeGetter: (_) => beforeInitialize = true,
        afterInitializeGetter: (_) => afterInitialize = true,
        beforeCreateGetter: (_) => beforeCreate = true,
        afterCreateGetter: (_) => afterCreate = true,
        beforeSaveGetter: (_) => beforeSave = true,
        afterSaveGetter: (_) => afterSave = true,
        beforeDeleteGetter: (_) => beforeDelete = true,
        afterDeleteGetter: (_) => afterDelete = true,
      ),
      TestData.new,
      entityTypeName: 'TestEntity',
      valueObjectTypeName: 'TestData',
    ).memory();

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

  test('lifecycle accessing id', () async {
    String? id;
    final repository = Repository.forType<TestEntity, TestData>(
      () => TestEntity(afterSaveGetter: (e) => id = e.id),
      TestData.new,
      entityTypeName: 'TestEntity',
      valueObjectTypeName: 'TestData',
    ).memory();

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    final entity = TestEntity()..set(TestData());

    expect(id, isNull);
    final updatedState = await repository.update(entity);
    expect(id, updatedState.id);
  });
}

class TestData extends ValueObject {
  late final counterProperty = field<int>(name: 'counter').withFallbackReplacement(() => 0);

  @override
  List<ValueObjectBehavior> get behaviors => [counterProperty];
}

class TestEntity extends Entity<TestData> {
  final FutureOr Function(TestEntity entity)? beforeInitializeGetter;
  final FutureOr Function(TestEntity entity)? afterInitializeGetter;
  final FutureOr Function(TestEntity entity)? beforeCreateGetter;
  final FutureOr Function(TestEntity entity)? afterCreateGetter;
  final FutureOr Function(TestEntity entity)? beforeSaveGetter;
  final FutureOr Function(TestEntity entity)? afterSaveGetter;
  final FutureOr Function(TestEntity entity)? beforeDeleteGetter;
  final FutureOr Function(TestEntity entity)? afterDeleteGetter;

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
    await beforeInitializeGetter?.call(this);
    return state.withData(state.data.copy()..update('counter', (counter) => counter + 1));
  }

  @override
  FutureOr onAfterInitalize(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await afterInitializeGetter?.call(this);
  }

  @override
  FutureOr onBeforeCreate(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await beforeCreateGetter?.call(this);
  }

  @override
  FutureOr onAfterCreate(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await afterCreateGetter?.call(this);
  }

  @override
  FutureOr onBeforeSave(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await beforeSaveGetter?.call(this);
  }

  @override
  FutureOr onAfterSave(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await afterSaveGetter?.call(this);
  }

  @override
  FutureOr onBeforeDelete(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await beforeDeleteGetter?.call(this);
  }

  @override
  FutureOr onAfterDelete(DropCoreContext context) async {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return await afterDeleteGetter?.call(this);
  }
}
