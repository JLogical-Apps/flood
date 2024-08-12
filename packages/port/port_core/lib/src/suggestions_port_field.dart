import 'package:port_core/src/port_field.dart';

class SuggestionsPortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final Future<List<T>> Function(T value) suggestionsGetter;

  SuggestionsPortField({required this.portField, required this.suggestionsGetter});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return SuggestionsPortField(
      portField: portField.copyWith(value: value, error: error),
      suggestionsGetter: suggestionsGetter,
    );
  }

  Future<List<T>> getSuggestions(T value) async {
    return await suggestionsGetter(value);
  }
}
