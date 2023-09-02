import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';

class ModelAppComponent with IsAppPondComponent {
  final ModelBuilderConfig modelBuilderConfig;

  ModelAppComponent({required this.modelBuilderConfig});

  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return Provider<ModelBuilderConfig>(
      create: (_) => modelBuilderConfig,
      child: app,
    );
  }
}
