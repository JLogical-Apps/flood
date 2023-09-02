import 'package:flutter/material.dart';

class ModelBuilderConfig {
  final Widget? loadingIndicator;
  final Widget Function(dynamic error, StackTrace stacktrace)? errorBuilder;

  ModelBuilderConfig({this.loadingIndicator, this.errorBuilder});
}
