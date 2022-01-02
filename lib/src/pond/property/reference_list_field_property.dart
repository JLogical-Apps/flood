import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/utils/resolvable.dart';

import 'list_field_property.dart';

class ReferenceListFieldProperty<E extends Entity> extends ListFieldProperty<String> implements Resolvable {
  ReferenceListFieldProperty({
    required String name,
    List<E>? initialReferences,
    List<String>? initialValue,
  }) : super(name: name, initialValue: initialReferences?.map((entity) => entity.id!).toList() ?? initialValue);

  List<E?> _references = [];

  List<E?> get references => _references;

  set references(List<E?> references) {
    _references = references;
    value = references.map((entity) => entity!.id!).toList();
  }

  Future<void> resolve() {
    return loadOrNull();
  }

  Future<List<E?>> loadOrNull() async {
    _references = await Future.wait(value!.map((id) => AppContext.global.getOrNull<E>(id)));

    return _references;
  }
}
