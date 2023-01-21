import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';

AppPondContext useAppPondContext() {
  return useContext().appPondContext;
}
