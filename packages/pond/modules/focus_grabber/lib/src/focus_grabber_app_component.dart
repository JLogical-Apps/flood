import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

class FocusGrabberAppComponent with IsAppPondComponent {
  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: app,
        );
      },
    );
  }
}
