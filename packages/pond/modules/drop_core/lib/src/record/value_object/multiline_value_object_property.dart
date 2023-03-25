import 'package:drop_core/drop_core.dart';

class MultilineValueObjectProperty<G extends String?, S extends String?, L> with IsValueObjectPropertyWrapper<G, S, L> {
  @override
  final ValueObjectProperty<G, S, L> property;

  final bool isMultiline;

  MultilineValueObjectProperty({required this.property, this.isMultiline = true});
}
