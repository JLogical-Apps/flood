import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

class ValueObjectRegistration<V extends ValueObject, NullableV extends ValueObject?> {
  final V Function()? onCreate;

  final Set<Type> parents;

  final String? valueObjectName;
  final String? nullableValueObjectName;

  bool get isAbstract => onCreate == null;

  ValueObjectRegistration(this.onCreate, {Set<Type>? parents, this.valueObjectName, this.nullableValueObjectName})
      : this.parents = {
          ...?parents,
          ..._baseParentTypes,
        };

  ValueObjectRegistration.abstract({Set<Type>? parents, this.valueObjectName, this.nullableValueObjectName})
      : this.parents = {
          ...?parents,
          ..._baseParentTypes,
        },
        onCreate = null;

  Type get valueObjectType => V;

  Type get nullableValueObjectType => NullableV;

  String getValueObjectName() => valueObjectName ?? valueObjectType.toString();

  String getNullableValueObjectName() => nullableValueObjectName ?? nullableValueObjectType.toString();

  V create() => onCreate!();

  static Set<Type> get _baseParentTypes => {ValueObject, Record};
}
