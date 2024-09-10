import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';

class SuggestionsValueObjectProperty<T, S>
    with IsValueObjectPropertyWrapper<T, S, SuggestionsValueObjectProperty<T, S>> {
  @override
  final ValueObjectProperty<T, S, dynamic> property;

  final FutureOr<List<S>> Function(DropCoreContext, T value) suggestionsGetter;

  SuggestionsValueObjectProperty({required this.property, required this.suggestionsGetter});

  @override
  SuggestionsValueObjectProperty<T, S> copy() {
    return SuggestionsValueObjectProperty<T, S>(
      property: property.copy(),
      suggestionsGetter: suggestionsGetter,
    );
  }

  Future<List<S>> getSuggestions(DropCoreContext context, T value) async {
    return await suggestionsGetter(context, value);
  }
}
