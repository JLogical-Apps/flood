import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class MapperValueObjectProperty<G, S, G2, S2>
    with IsValueObjectProperty<G2, S2, MapperValueObjectProperty<G, S, G2, S2>> {
  final ValueObjectProperty<G, S, dynamic> property;
  final G2 Function(G) getMapper;
  final S Function(S2) setMapper;

  MapperValueObjectProperty({required this.property, required this.getMapper, required this.setMapper});

  @override
  Type get getterType => G;

  @override
  Type get setterType => S;

  @override
  String get name => property.name;

  @override
  State modifyState(DropCoreContext context, State state) {
    return property.modifyState(context, state);
  }

  @override
  Future<State> modifyStateForRepository(DropCoreContext context, State state) =>
      property.modifyStateForRepository(context, state);

  @override
  void fromState(DropCoreContext context, State state) {
    property.fromState(context, state);
  }

  @override
  Future<void> onDuplicateTo(DropCoreContext context, MapperValueObjectProperty<G, S, G2, S2> property) async {
    await this.property.onDuplicateTo(context, property.property);
  }

  @override
  Future<void> onBeforeSave(DropCoreContext context) async {
    await property.onBeforeSave(context);
  }

  @override
  Future<void> onDelete(DropCoreContext context) async {
    await property.onDelete(context);
  }

  @override
  G2 get value => getMapper(property.value);

  @override
  G2? get valueOrNull => property.valueOrNull == null ? null : getMapper(property.value);

  @override
  set(S2 value) => property.set(setMapper(value));

  @override
  FutureOr<String?> onValidate(ValueObject data) => property.validate(data);

  @override
  MapperValueObjectProperty<G, S, G2, S2> copy() {
    return MapperValueObjectProperty<G, S, G2, S2>(
      property: property.copy(),
      getMapper: getMapper,
      setMapper: setMapper,
    );
  }

  @override
  ValueObject get valueObject => property.valueObject;

  @override
  set valueObject(ValueObject value) => property.valueObject = value;
}
