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
    dynamic error,
  }) : portField = PortField(
          value: StageValue<E, T>(value: initialValue, port: portValue ?? portMapper(initialValue)),
          error: error,
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
  StagePortField<E, T> copyWith({required StageValue<E, T> value, required error}) {
    return StagePortField<E, T>(
      initialValue: value.value,
      options: options,
      portMapper: portMapper,
      portValue: value.port,
      error: error,
    );
  }

  StageValue<E, T> getStageValue(E newValue) {
    return StageValue(value: newValue, port: getMappedPort(newValue));
  }

  Port<T>? getMappedPort(E value) {
    return portMapper(value);
  }
}

class StageValue<E, T> {
  final E value;
  final Port<T>? port;

  StageValue({required this.value, required this.port});
}
