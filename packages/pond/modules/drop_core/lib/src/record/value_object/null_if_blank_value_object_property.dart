import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class NullIfBlankValueObjectProperty<G extends String?, S extends String?, L>
    with IsValueObjectPropertyWrapper<String?, String?, L, NullIfBlankValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  final bool useNullIfBlank;

  NullIfBlankValueObjectProperty({required this.property, this.useNullIfBlank = true});

  @override
  String? get value => super.value?.isBlank == true ? null : super.value;

  @override
  String? get valueOrNull => value;

  @override
  NullIfBlankValueObjectProperty<G, S, L> copy() {
    return NullIfBlankValueObjectProperty<G, S, L>(property: property.copy(), useNullIfBlank: useNullIfBlank);
  }

  @override
  List<Object?> get props => [property, useNullIfBlank];
}
