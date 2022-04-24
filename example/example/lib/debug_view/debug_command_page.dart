import 'package:example/debug_view/parameter/parameter_form_builder_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'debug_page.dart';

class DebugCommandPage extends HookWidget {
  final CommandStub commandStub;
  final Future<dynamic> Function(Map<String, dynamic> args) onExecute;

  const DebugCommandPage({Key? key, required this.commandStub, required this.onExecute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parameterFormBuilderFactory = ParameterFormBuilderFactory();
    final smartFormController = useMemoized(() => SmartFormController());

    final commandResult = useState<String?>(null);

    return StyleProvider(
      style: DebugPage.style,
      child: Builder(builder: (context) {
        return StyledPage(
          titleText: commandStub.nameProperty.value,
          body: SmartForm(
            controller: smartFormController,
            child: ScrollColumn.withScrollbar(children: [
              ...commandStub.parametersProperty.value!.mapToIterable((name, stub) =>
                  parameterFormBuilderFactory.getParameterFormBuilderByParameterOrNull(stub)!.buildForm(name, stub)),
              StyledButton.high(
                text: 'Execute',
                onTapped: () async {
                  final result = await smartFormController.validate();
                  if (!result.isValid) {
                    return;
                  }

                  final data = result.valueByName!;
                  commandResult.value = (await onExecute(data))?.toString() ?? 'N/A';
                },
              ),
              if (commandResult.value != null) ...[
                StyledDivider(),
                StyledBodyText(commandResult.value!),
              ],
            ]),
          ),
        );
      }),
    );
  }
}
