import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';

extension AppPondContextBuildContextExtensions on BuildContext {
  AppPondContext get appPondContext => Provider.of<AppPondContext>(this, listen: false);
}
