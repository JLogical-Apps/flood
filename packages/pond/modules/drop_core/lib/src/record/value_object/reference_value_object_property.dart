import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class ReferenceValueObjectProperty<E extends Entity>
    with IsValueObjectProperty<String?, String?, ReferenceValueObjectProperty<E>> {
  @override
  final String name;

  final FutureOr<Query<E>> Function(DropCoreContext context)? searchQueryGetter;
  final FutureOr<List<E>> Function(DropCoreContext context, List<E> results)? searchResultsFilter;

  @override
  String? value;

  ReferenceValueObjectProperty({
    required this.name,
    this.value,
    this.searchQueryGetter,
    this.searchResultsFilter,
  });

  @override
  Type get getterType => typeOf<String?>();

  @override
  Type get setterType => typeOf<String?>();

  Type get entityType => E;

  @override
  set(String? value) => this.value = value;

  @override
  void fromState(DropCoreContext context, State state) {
    value = state[name] as String?;
  }

  @override
  State modifyState(DropCoreContext context, State state) {
    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  ReferenceValueObjectProperty<E> copy() {
    return ReferenceValueObjectProperty<E>(
      name: name,
      value: value,
      searchResultsFilter: searchResultsFilter,
      searchQueryGetter: searchQueryGetter,
    );
  }

  Future<List<E>> getSearchResults(DropCoreContext context) async {
    final query = searchQueryGetter == null ? Query.from<E>() : await searchQueryGetter!(context);

    var entities = await query.all().get(context);
    if (searchResultsFilter != null) {
      entities = await searchResultsFilter!(context, entities);
    }

    return entities;
  }
}
