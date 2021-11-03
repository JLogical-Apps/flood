import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/record/has_id.dart';

class ReferenceProperty<R extends HasId> extends Property<String> with WithGlobalTypeSerializer {
  set reference(R reference) {
    final id = reference.id;
    if(id == null){
      throw Exception('Cannot set a property to reference something with a null id!');
    }
    value = id;
  }

  ReferenceProperty({required String name, R? initialValue}) : super(name: name, initialValue: initialValue?.id);
}
