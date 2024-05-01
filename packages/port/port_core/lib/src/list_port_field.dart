import 'package:collection/collection.dart';
import 'package:port_core/src/port.dart';
import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/port_field_provider.dart';
import 'package:port_core/src/port_field_validator_context.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class ListPortField<T, S> with IsPortFieldWrapper<Map<String, T?>, List<S>> {
  @override
  final PortField<Map<String, T?>, List<S>> portField;

  final PortField<T, S> Function(T? value) itemPortFieldGenerator;

  final Map<String, PortField> _initialItemPortFieldById;

  late final Map<String, PortField> itemPortFieldById = Map.fromEntries(value.entries.mapIndexed((i, entry) {
    final (id, value) = entry.asRecord();
    return MapEntry(
      id,
      _initialItemPortFieldById[id] ?? (itemPortFieldGenerator(value)..registerToPort('$fieldPath/$i', port)),
    );
  }));

  ListPortField({
    required this.portField,
    required this.itemPortFieldGenerator,
    Map<String, PortField>? initialItemPortFieldById,
  }) : _initialItemPortFieldById = initialItemPortFieldById ?? {};

  @override
  Map<String, T?> parseValue(value) {
    if (value is List) {
      return value.mapToMap((value) => MapEntry(Uuid().v4(), value));
    }
    return value;
  }

  @override
  List<S> submitRaw(Map<String, T?> value) {
    return itemPortFieldById.mapToIterable((id, portField) => portField.submitRaw(portField.value)).cast<S>().toList();
  }

  @override
  Future<List<S>> submit(Map<String, T?> value) async {
    return (await Future.wait(
            itemPortFieldById.mapToIterable((id, portField) async => await portField.submit(portField.value))))
        .cast<S>()
        .toList();
  }

  @override
  PortField<Map<String, T?>, List<S>> copyWith({required Map value, required error}) {
    return ListPortField<T, S>(
      portField: portField.copyWith(value: value.cast<String, T?>(), error: error),
      itemPortFieldGenerator: itemPortFieldGenerator,
      initialItemPortFieldById: itemPortFieldById,
    );
  }

  @override
  Validator<PortFieldValidatorContext, String> get validator =>
      portField.validator +
      Validator((context) async {
        for (final portField in itemPortFieldById.values) {
          final error = await portField.validate(PortFieldValidatorContext(value: portField.value, port: port));
          if (error != null) {
            return error;
          }
        }

        return null;
      });

  @override
  PortFieldProvider? getPortFieldProviderOrNull() {
    return PortFieldProvider(
      fieldGetter: (name) {
        final index = int.parse(name);
        final id = value.keys.toList()[index];
        final currentValue = value.values.toList()[index];
        return _initialItemPortFieldById.putIfAbsent(
            id, () => itemPortFieldGenerator(currentValue)..registerToPort('$fieldPath/$index', port));
      },
      portFieldSetter: (name, portField) {
        final index = int.parse(name);
        final id = value.keys.toList()[index];
        port.setValue(
          path: fieldPath,
          value: value.copy()..set(id, portField.value as T),
        );
      },
    );
  }
}
