import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

import '../../query/query.dart';
import 'default_abstract_firestore_repository.dart';

class SimpleFirestoreRepository<E extends Entity<V>, V extends ValueObject>
    extends DefaultAbstractFirestoreRepository<E, V> {
  @override
  final String dataPath;

  /// The name of the field that stores the union type of
  final String unionTypeFieldName;

  /// Converts [type] (the name of a type that extends `E`) to a string to be queried/saved.
  /// The state of extracted documents will find the first [type] in the list of handled types that has the same value.
  final String Function(String typeName) unionTypeConverterGetter;

  final Type? inferredType;

  final List<ValueObjectRegistration> valueObjectRegistrations;
  final List<EntityRegistration> entityRegistrations;

  SimpleFirestoreRepository({
    required this.dataPath,
    this.unionTypeFieldName: Query.type,
    this.unionTypeConverterGetter: _defaultUnionTypeConverterGetter,
    this.inferredType,
    required this.valueObjectRegistrations,
    required this.entityRegistrations,
  });

  @override
  String unionTypeConverter(String typeName) => unionTypeConverterGetter(typeName);
}

String _defaultUnionTypeConverterGetter(String typeName) {
  return typeName;
}
