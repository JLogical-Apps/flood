import 'package:flutter/material.dart';
import 'package:path_core/path_core.dart';

abstract class AppPage extends StatelessWidget with IsRoute, IsPathDefinitionWrapper {
  AppPage copy();
}
