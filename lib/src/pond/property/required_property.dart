import 'package:jlogical_utils/jlogical_utils.dart';

class RequiredProperty<T> extends Property<T> {
  final Property<T?> parent;

  RequiredProperty({required this.parent})
      : super(
          name: parent.name,
          initialValue: parent.getUnvalidated(),
        );

  @override
  T? getUnvalidated() {
    return parent.getUnvalidated();
  }

  @override
  void setUnvalidated(T value) {
    return parent.setUnvalidated(value);
  }

  @override
  TypeStateSerializer get typeStateSerializer => parent.typeStateSerializer;

  @override
  void validate() {
    if (getUnvalidated() == null) {
      throw ValidationException(
        failedValidator: this,
        errorMessage: 'Required property cannot be null!',
      );
    }
  }
}
