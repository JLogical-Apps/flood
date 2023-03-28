import 'package:port_core/port_core.dart';
import 'package:utils_core/utils_core.dart';

class StagePortField<E, T> with IsPortFieldWrapper<StageValue<E, T>, T?> {
  @override
  final PortField<StageValue<E, T>, T?> portField;

  final List<E> options;
  final Port<T>? Function(E option) portMapper;

  StagePortField({
    required E initialValue,
    required this.options,
    required this.portMapper,
    Port<T>? portValue,
  }) : portField = PortField(
          value: StageValue(value: initialValue, port: portValue ?? portMapper(initialValue)),
          validator: Validator((stageValue) async {
            final port = stageValue.port;
            if (port == null) {
              return null;
            }

            final result = await port.submit();
            if (!result.isValid) {
              return 'Error when submitting stage port!';
            }

            return null;
          }),
          submitMapper: (stageValue) async {
            final result = await stageValue.port?.submit();
            return result?.dataOrNull;
          },
        );

  @override
  PortField<StageValue<E, T>, T?> copyWith({required StageValue<E, T> value, required error}) {
    return StagePortField(
      initialValue: value.value,
      options: options,
      portMapper: portMapper,
      portValue: value.port,
    );
  }

  StageValue<E, T> getStageValue(E newValue) {
    return StageValue(value: newValue, port: portMapper(newValue));
  }
}

class StageValue<E, T> {
  final E value;
  final Port<T>? port;

  StageValue({required this.value, required this.port});
}
