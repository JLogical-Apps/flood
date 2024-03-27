import 'package:flood/flood.dart';
import 'package:flutter/material.dart';

class OutdatedRoute with IsRoute<OutdatedRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('outdated');

  @override
  OutdatedRoute copy() {
    return OutdatedRoute();
  }
}

class OutdatedPage with IsAppPage<OutdatedRoute> {
  @override
  Widget onBuild(BuildContext context, OutdatedRoute route) {
    return StyledPage(
      titleText: 'Update Needed',
      body: Center(
        child: StyledText.body('You need to update!'),
      ),
    );
  }
}
