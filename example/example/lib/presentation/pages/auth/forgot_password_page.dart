import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ForgotPasswordRoute with IsRoute<ForgotPasswordRoute> {
  static const initialEmailField = 'initialEmail';
  late final initialEmailProperty = field<String>(name: initialEmailField);

  @override
  PathDefinition get pathDefinition => PathDefinition.string('forgot-password');

  @override
  List<RouteProperty> get hiddenProperties => [initialEmailProperty];

  @override
  ForgotPasswordRoute copy() {
    return ForgotPasswordRoute();
  }
}

class ForgotPasswordPage with IsAppPageWrapper<ForgotPasswordRoute> {
  @override
  AppPage<ForgotPasswordRoute> get appPage => AppPage<ForgotPasswordRoute>().onlyIfNotLoggedIn();

  @override
  Widget onBuild(BuildContext context, ForgotPasswordRoute route) {
    final emailPort = useMemoized(() => Port.of({
          'email': PortField.string().withDisplayName('Email').isNotBlank().isEmail(),
        }).map((values, port) => values['email'] as String));
    final hasSubmittedState = useState<bool>(false);

    return StyledPage(
      titleText: 'Forgot Password',
      body: StyledList.column.withScrollbar.centered(
        children: [
          StyledText.body.subtle.centered(
              "Enter your email and you'll receive an email with a password-reset link. Make sure to check your spam folder."),
          StyledObjectPortBuilder(port: emailPort),
          StyledButton.strong(
            labelText: 'Send Password Reset Link',
            onPressed: hasSubmittedState.value
                ? null
                : () async {
                    final result = await emailPort.submit();
                    if (!result.isValid) {
                      return;
                    }

                    try {
                      await context.authCoreComponent.resetPassword(result.data);
                      hasSubmittedState.value = true;
                    } catch (error, stackTrace) {
                      context.showStyledMessage(StyledMessage.error(labelText: error.toString()));
                      context.logError(error, stackTrace);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
