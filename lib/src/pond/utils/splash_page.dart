import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_loading_indicator.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_page.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_error_text.dart';

import '../../utils/export.dart';
import '../modules/logging/default_logging_module.dart';

class SplashPage extends HookWidget {
  final Widget child;

  final FutureOr<void> Function(BuildContext context)? beforeLoad;

  final FutureOr<void> Function(BuildContext context)? onDone;

  SplashPage({required this.child, this.beforeLoad, this.onDone});

  @override
  Widget build(BuildContext context) {
    final error = useState<String?>(null);

    useOneTimeEffect(() {
      () async {
        try {
          await beforeLoad?.call(context);
          await AppContext.global.load();
          await onDone?.call(context);
        } catch (e, stack) {
          logError(e, stack: stack);
          error.value = e.toString();
          rethrow;
        }
      }();
    });
    return StyledPage(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
            SizedBox(height: 30),
            if (error.value == null) StyledLoadingIndicator(),
            if (error.value != null) StyledErrorText(error.value!),
          ],
        ),
      ),
    );
  }
}
