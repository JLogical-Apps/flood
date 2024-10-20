import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/time/timestamp.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';

class CreationTimeProperty with IsValueObjectPropertyWrapper<Timestamp?, Timestamp?, CreationTimeProperty> {
  static const field = 'creationTime';

  @override
  final ValueObjectProperty<Timestamp?, Timestamp?, dynamic> property;

  CreationTimeProperty({ValueObjectProperty<Timestamp?, Timestamp?, dynamic>? property})
      : property = property ??
            ValueObjectProperty.field<Timestamp>(name: field)
                .time()
                .withDisplayName('Creation Time')
                .hidden()
                .withFallbackReplacement(() => Timestamp.now());

  @override
  CreationTimeProperty copy() {
    return CreationTimeProperty(property: property.copy());
  }

  @override
  Future<void> onDuplicateTo(DropCoreContext context, CreationTimeProperty property) async {
    property.set(Timestamp.now());
  }
}

extension CreationTimeExtensions on ValueObject {
  DateTime get timeCreated {
    final timestamp = behaviors
        .whereType<ValueObjectProperty>()
        .firstWhere((property) => property.name == CreationTimeProperty.field)
        .value as Timestamp;
    return timestamp.time;
  }
}
