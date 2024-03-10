import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

extension OtpBuildContextExtensions on BuildContext {
  Future<Account?> loginWithPhoneOtp() async {
    final result = await showStyledDialog(StyledPortDialog(
      titleText: 'Login with Phone',
      port: Port.of({
        'phone': PortField.string().withDisplayName('Phone').isPhone().isNotBlank(),
      }),
    ));
    if (result == null) {
      return null;
    }

    final otpPort = Port.of({
      'otp': PortField.string().withDisplayName('Code').isNotBlank(),
    }).map((values, port) => values['otp'] as String);
    final accountOrError = await showStyledDialog(StyledDialog(
      titleText: 'Verify Phone Number',
      body: HookBuilder(
        builder: (context) {
          final otpResultCompleter = useRef<Completer<String>>(Completer());
          final otpRequestTypeState = useState<OtpRequestType>(OtpRequestType.initial);
          useAsyncEffect(() async {
            try {
              final account = await authCoreComponent.loginWithOtp(OtpProvider.phone(
                phoneNumber: result['phone'],
                smsCodeGetter: (requestType) async {
                  otpRequestTypeState.value = requestType;
                  otpResultCompleter.value = Completer();
                  return await otpResultCompleter.value.future;
                },
              ));
              Navigator.of(context).pop(account);
            } catch (e) {
              Navigator.of(context).pop(Exception('Unable to verify phone number!'));
            }
          });

          return StyledList.column(
            children: [
              StyledText.body('Enter the code that was sent to your phone number.'),
              if (otpRequestTypeState.value == OtpRequestType.retry)
                StyledText.body.error('Incorrect code. Try again.'),
              StyledObjectPortBuilder(port: otpPort),
              StyledButton(
                labelText: 'Verify',
                onPressed: () async {
                  final result = await otpPort.submit();
                  if (!result.isValid) {
                    return;
                  }

                  otpResultCompleter.value.complete(result.data);
                },
              ),
            ],
          );
        },
      ),
    ));
    if (accountOrError is Account) {
      return accountOrError;
    }

    throw accountOrError;
  }
}
