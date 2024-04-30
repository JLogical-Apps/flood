import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class NullIfBlankValueObjectProperty<G extends String?, S extends String?>
    with IsValueObjectPropertyWrapper<String?, String?, NullIfBlankValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  final bool useNullIfBlank;

  NullIfBlankValueObjectProperty({required this.property, this.useNullIfBlank = true});

  @override
  String? get value => super.value?.isBlank == true ? null : super.value;

  @override
  String? get valueOrNull => value;

  @override
  NullIfBlankValueObjectProperty<G, S> copy() {
    return NullIfBlankValueObjectProperty<G, S>(property: property.copy(), useNullIfBlank: useNullIfBlank);
  }
}
