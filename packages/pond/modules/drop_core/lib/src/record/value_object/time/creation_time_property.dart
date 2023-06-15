import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/time/timestamp.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';

class CreationTimeProperty with IsValueObjectPropertyWrapper<Timestamp?, Timestamp?, dynamic, CreationTimeProperty> {
  static const field = 'creationTime';

  @override
  late final property = ValueObjectProperty.field<Timestamp>(name: field)
      .time()
      .withDisplayName('Creation Time')
      .hidden()
      .withFallbackReplacement(() => Timestamp.now());

  @override
  CreationTimeProperty copy() {
    return CreationTimeProperty();
  }

  @override
  List<Object?> get props => [property];
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
