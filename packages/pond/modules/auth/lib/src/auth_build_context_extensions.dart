import 'package:auth_core/auth_core.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

extension AuthBuildContextExtensions on BuildContext {
  AuthCoreComponent get authCoreComponent => find<AuthCoreComponent>();
}
