import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validators.dart';

class Envelope extends Entity {
  late final StringProperty nameProperty = StringProperty(
    name: 'name',
    validators: [PropertyValidators.required()],
  );

  late final IntProperty centsProperty = IntProperty(
    name: 'cents',
    validators: [PropertyValidators.required()],
  );
}