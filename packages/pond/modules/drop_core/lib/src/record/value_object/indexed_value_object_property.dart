import 'package:drop_core/drop_core.dart';

class IndexedValueObjectProperty<G, S> with IsValueObjectPropertyWrapper<G, S, IndexedValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  final bool Function()? isIndexedGetter;

  IndexedValueObjectProperty({required this.property, required this.isIndexedGetter});

  bool get isIndexed => isIndexedGetter?.call() ?? true;

  @override
  IndexedValueObjectProperty<G, S> copy() {
    return IndexedValueObjectProperty<G, S>(property: property.copy(), isIndexedGetter: isIndexedGetter);
  }
}
