import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('lifecycle methods', () async {
    var beforeCreate = false;
    var afterCreate = false;
    var beforeSave = false;
    var afterSave = false;
    var beforeDelete = false;
    var afterDelete = false;

    final repository = Repository.memory().forType<TestEntity, TestData>(
      () => TestEntity(
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

    var entity = TestEntity()..set(TestData());

    var updatedState = await repository.update(entity);
    entity = context.dropCoreComponent.constructEntityFromState(updatedState);

    expect(beforeCreate, true);
    expect(afterCreate, true);
    expect(beforeSave, true);
    expect(afterSave, true);
    expect(beforeDelete, false);
    expect(afterDelete, false);
    expect(entity.value.counterProperty.value, 4);

    beforeCreate = false;
    afterCreate = false;
    beforeSave = false;
    afterSave = false;

    updatedState = await repository.update(updatedState);
    entity = context.dropCoreComponent.constructEntityFromState(updatedState);

    expect(beforeCreate, false);
    expect(afterCreate, false);
    expect(beforeSave, true);
    expect(afterSave, true);
    expect(beforeDelete, false);
    expect(afterDelete, false);
    expect(entity.value.counterProperty.value, 6);

    beforeSave = false;
    afterSave = false;

    updatedState = await repository.delete(updatedState);
    entity = context.dropCoreComponent.constructEntityFromState(updatedState);

    expect(beforeCreate, false);
    expect(afterCreate, false);
    expect(beforeSave, false);
    expect(afterSave, false);
    expect(beforeDelete, true);
    expect(afterDelete, true);
    expect(entity.value.counterProperty.value, 8);
  });
}

class TestData extends ValueObject {
  late final counterProperty = field<int>(name: 'counter').withFallbackReplacement(() => 0);

  @override
  List<ValueObjectBehavior> get behaviors => [counterProperty];
}

class TestEntity extends Entity<TestData> {
  final FutureOr Function()? beforeCreateGetter;
  final FutureOr Function()? afterCreateGetter;
  final FutureOr Function()? beforeSaveGetter;
  final FutureOr Function()? afterSaveGetter;
  final FutureOr Function()? beforeDeleteGetter;
  final FutureOr Function()? afterDeleteGetter;

  TestEntity({
    this.beforeCreateGetter,
    this.afterCreateGetter,
    this.beforeSaveGetter,
    this.afterSaveGetter,
    this.beforeDeleteGetter,
    this.afterDeleteGetter,
  });

  @override
  FutureOr onBeforeCreate(DropCoreContext context) {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return beforeCreateGetter?.call();
  }

  @override
  FutureOr onAfterCreate(DropCoreContext context) {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return afterCreateGetter?.call();
  }

  @override
  FutureOr onBeforeSave(DropCoreContext context) {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return beforeSaveGetter?.call();
  }

  @override
  FutureOr onAfterSave(DropCoreContext context) {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return afterSaveGetter?.call();
  }

  @override
  FutureOr onBeforeDelete(DropCoreContext context) {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return beforeDeleteGetter?.call();
  }

  @override
  FutureOr onAfterDelete(DropCoreContext context) {
    value = TestData()
      ..copyFrom(context, value)
      ..counterProperty.set(value.counterProperty.value + 1);
    return afterDeleteGetter?.call();
  }
}
