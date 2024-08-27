import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:log/log.dart';
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
  final List<String> Function(R? value)? stringSearchMapper;

  const StyledSearchPortField({
    super.key,
    required this.fieldPath,
    this.labelText,
    this.label,
    this.enabled = true,
    this.widgetMapper,
    this.stringSearchMapper,
  });

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<R>(
      fieldPath: fieldPath,
      builder: (context, field, value, error) {
        final searchField =
            field.findSearchFieldOrNull() ?? (throw Exception('Could not find search field for port field [$field]'));
        final selectedValueState = useState<R?>(null);

        final searchX = useMemoizedFuture(() async => await searchField.searchX());
        final results = useValueStreamOrNull(searchX.getOrNull()) ?? FutureValue.loading();
        useListen(
          searchX.getOrNull(),
          (FutureValue<List> maybeResults) {
            maybeResults.maybeWhen(
              onLoaded: (results) => selectedValueState.value = searchField.getResult(value, results),
              onError: (error, stackTrace) => context.logError(error, stackTrace),
              orElse: () {},
            );
          },
        );

        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: 70),
          child: results.maybeWhen(
            onLoaded: (results) => StyledOptionField<R?>(
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
                ...results.cast<R>(),
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
              stringSearchMapper: stringSearchMapper,
            ),
            onError: (error, stackTrace) => StyledText.body.error(error.toString()),
            orElse: () => StyledDisabledTextField(
              labelText: label == null ? (labelText ?? field.findDisplayNameOrNull()) : null,
              label: label,
              leading: StyledLoadingIndicator(),
              showRequiredIndicator: field.findIsRequired(),
            ),
          ),
        );
      },
    );
  }
}
