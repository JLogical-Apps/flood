import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/src/app/context/app_context.dart';

class PondApp extends StatelessWidget {
  final AppContext appContext;

  const PondApp({super.key, required this.appContext});

  @override
  Widget build(BuildContext context) {
    final doneLoadingValue = useState(false);
    useMemoized(() => () async {
          AppContext.global = appContext;
          await Future.delayed(Duration(seconds: 3));
          doneLoadingValue.value = true;
        }());
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(doneLoadingValue.value ? 'Done!' : 'Loading...')),
      ),
    );
  }
}
