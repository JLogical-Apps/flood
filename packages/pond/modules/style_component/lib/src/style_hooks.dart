import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/style.dart';
import 'package:style_component/src/style_app_component.dart';
import 'package:utils/utils.dart';

Style useStyle() {
  return useValueStream(useContext().styleAppComponent.styleX);
}
