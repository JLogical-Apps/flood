import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TestHomePage extends StatelessWidget {
  final Style style;

  const TestHomePage({Key? key, required this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyleProvider(
      style: style,
      child: Scaffold(
        backgroundColor: (style as dynamic).backgroundColor,
        body: Center(
          child: StyledContent(
            header: 'Test of Content',
            content: 'This is a test as to whether the content body looks decent at all right now :-)',
            lead: StyledIcon(Icons.calendar_today),
            onTap: () => print('hey'),
            children: [
              ButtonBar(
                children: [
                  StyledButton.high(
                    text: 'Sign Up',
                    onTap: () {},
                  ),
                  StyledButton.low(
                    text: 'Log In',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
