import 'package:example/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopePage extends AppPage {
  late final idProperty = field<String>(name: 'id').required();
  late final trayIdProperty = field<String>(name: 'trayId');

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      titleText: 'Envelope',
      body: Column(
        children: [
          StyledText.h1(idProperty.value),
          StyledText.h1(trayIdProperty.value ?? ''),
          OutlinedButton(
            child: Text('Last Transaction (Warp)'),
            onPressed: () {
              context.warpTo(HomePage());
            },
          ),
          OutlinedButton(
            child: Text('Last Transaction (Push)'),
            onPressed: () {
              context.push(HomePage());
            },
          ),
        ],
      ),
    );
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('envelope').property(idProperty);

  @override
  List<RouteProperty> get queryProperties => [
        trayIdProperty,
      ];

  @override
  AppPage copy() {
    return EnvelopePage();
  }

  @override
  AppPage? getParent() {
    return HomePage();
  }
}
