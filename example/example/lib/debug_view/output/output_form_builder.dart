import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class OutputFormBuilder<T> extends Wrapper<dynamic> with WithSubtypeWrapper<T, dynamic> {
  Widget build(T value);
}
