import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/record/has_id.dart';

class ReferenceProperty<R extends HasId> extends Property<String> with WithGlobalTypeSerializer {
  set reference(R? reference) => value = reference?.id;

  ReferenceProperty({required String name, R? initialValue}) : super(name: name, initialValue: initialValue?.id);
}
