import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      titleText: 'Home',
      body: Center(
        child: StyledText.h1('Home'),
      ),
    );
  }

  @override
  AppPage copy() {
    return HomePage();
  }
}
