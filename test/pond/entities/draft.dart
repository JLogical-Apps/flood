import 'package:jlogical_utils/jlogical_utils.dart';

class Draft extends ValueObject {
  late final stateProperty = MapFieldProperty<String, dynamic>(name: 'state');

  State get draftState => State.extractFrom(stateProperty.value);

  set draftState(State state) {
    stateProperty.value = state.fullValues;
  }

  @override
  List<Property> get properties => super.properties + [stateProperty];
}
