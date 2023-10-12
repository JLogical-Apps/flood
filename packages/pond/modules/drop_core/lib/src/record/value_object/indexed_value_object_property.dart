import 'package:drop_core/drop_core.dart';

class IndexedValueObjectProperty<G, S, L>
    with IsValueObjectPropertyWrapper<G, S, L, IndexedValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  final bool Function()? isIndexedGetter;

  IndexedValueObjectProperty({required this.property, required this.isIndexedGetter});

  bool get isIndexed => isIndexedGetter?.call() ?? true;

  @override
  IndexedValueObjectProperty<G, S, L> copy() {
    return IndexedValueObjectProperty<G, S, L>(property: property.copy(), isIndexedGetter: isIndexedGetter);
  }
}
