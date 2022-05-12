import 'package:example/debug_view/output/output_form_builder_factory.dart';
import 'package:example/debug_view/parameter/parameter_form_builder_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'debug_page.dart';

class DebugCommandPage extends HookWidget {
  final CommandStub commandStub;
  final Future<dynamic> Function(Map<String, dynamic> args) onExecute;

  DebugCommandPage({Key? key, required this.commandStub, required this.onExecute}) : super(key: key);

  final parameterFormBuilderFactory = ParameterFormBuilderFactory();
  final outputFormBuilderFactory = OutputFormBuilderFactory();

  @override
  Widget build(BuildContext context) {
    final port = useMemoized(() => Port());

    final commandResult = useState<dynamic>(null);
    final outputLoaded = useState<bool>(false);

    return StyleProvider(
      style: DebugPage.style,
      child: Builder(builder: (context) {
        return StyledPage(
          titleText: commandStub.displayNameProperty.value,
          body: PortBuilder(
            port: port,
            child: ScrollColumn.withScrollbar(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (commandStub.descriptionProperty.value != null)
                  StyledContentSubtitleText(commandStub.descriptionProperty.value!),
                ...commandStub.parametersProperty.value!.map((stub) =>
                    parameterFormBuilderFactory.getParameterFormBuilderByParameterOrNull(stub)!.buildForm(stub)),
                StyledButton.high(
                  text: 'Execute',
                  onTapped: () async {
                    final result = await port.submit();
                    if (!result.isValid) {
                      return;
                    }

                    final args = commandStub.parametersProperty.value!
                        .map((stub) =>
                            MapEntry(stub.nameProperty.value!, _getArgValue(stub, result[stub.nameProperty.value!])))
                        .toMap();

                    commandResult.value = await onExecute(args);
                    outputLoaded.value = true;
                  },
                ),
                PortUpdateBuilder(builder: (port) {
                  return _executeCommandText(port);
                }),
                StyledDivider(),
                if (outputLoaded.value)
                  outputFormBuilderFactory
                      .getOutputFormBuilderByValueOrNull(commandResult.value)!
                      .build(commandResult.value),
              ],
            ),
          ),
        );
      }),
    );
  }

  StyledDescriptionText _executeCommandText(Port port) {
    final parameters = commandStub.parametersProperty.value!.map((param) {
      final name = param.nameProperty.value!;
      return '  >$name<: ${_getArgValue(param, port[name])}';
    }).join('\n');
    return StyledDescriptionText(
      inputString: '>${commandStub.nameProperty.value}<\n$parameters',
      overrides: StyledTextOverrides(fontStyle: FontStyle.italic),
    );
  }

  dynamic _getArgValue(CommandParameterStub stub, dynamic formValue) {
    return parameterFormBuilderFactory.getParameterFormBuilderByParameterOrNull(stub)!.transformValue(formValue);
  }
}
