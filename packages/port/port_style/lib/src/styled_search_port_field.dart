import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:port_style/src/styled_search_result_overrides.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class StyledSearchPortField<R> extends HookWidget {
  final String fieldPath;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  final Widget Function(R? value)? widgetMapper;

  const StyledSearchPortField({
    super.key,
    required this.fieldPath,
    this.labelText,
    this.label,
    this.enabled = true,
    this.widgetMapper,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<R>(
      fieldPath: fieldPath,
      builder: (context, field, value, error) {
        final searchField =
            field.findSearchFieldOrNull() ?? (throw Exception('Could not find search field for port field [$field]'));
        final resultsState = useState<List?>(null);
        final selectedValueState = useState<R?>(null);

        return HookBuilder(builder: (context) {
          useAsyncEffect(() async {
            final results = await searchField.search();
            resultsState.value = results;
            selectedValueState.value = value == null ? null : searchField.getResult(value, results);
          });

          if (resultsState.value == null) {
            return StyledDisabledTextField(
              labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
              label: label,
              leading: StyledLoadingIndicator(),
              showRequiredIndicator: field.findIsRequired(),
            );
          }

          return StyledOptionField<R?>(
            value: selectedValueState.value,
            labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
            label: label,
            showRequiredIndicator: field.findIsRequired(),
            errorText: error?.toString(),
            enabled: enabled,
            onChanged: (value) {
              port[fieldPath] = searchField.getValue(value);
              selectedValueState.value = value;
            },
            options: [
              null,
              ...resultsState.value!.cast<R>(),
            ],
            widgetMapper: widgetMapper ??
                (result) {
                  if (result == null) {
                    return StyledText.body.thin('(None)');
                  }
                  final searchResultOverrides = context.read<StyledSearchResultOverrides>();
                  final override = searchResultOverrides.getOverrideOrNull(result);
                  return override?.build(result) ?? StyledText.body('$result');
                },
          );
        });
      },
    );
  }
}
