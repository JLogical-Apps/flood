import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TestHomePage extends HookWidget {
  final Style style;

  const TestHomePage({Key? key, required this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkboxValue = useState(false);
    return StyleProvider(
      style: style,
      child: StyledPage(
        title: 'Welcome',
        actions: [
          ActionItem(
            name: 'Edit',
            color: Colors.orange,
            lead: StyledIcon(Icons.edit),
            description: 'Edit nothing. XD',
            onPerform: () {
              print('Ouch you poked me!');
            },
          )
        ],
        body: ScrollColumn(
          children: [
            StyledContent.high(
              header: 'This is a high emphasis content',
              lead: StyledIcon(Icons.calendar_today),
              onTap: () => print('hey'),
              actions: [
                ActionItem(
                  name: 'Save',
                  color: Colors.blue,
                  description: 'This does nothing yet.',
                  lead: StyledIcon(Icons.save),
                  onPerform: () {
                    print('SAVING');
                  },
                ),
              ],
            ),
            StyledContent.low(
              header: 'Test of Content',
              content: 'This is a test as to whether the content body looks decent at all right now :-)',
              lead: StyledIcon(Icons.calendar_today),
              onTap: () => print('hey'),
              children: [
                ButtonBar(
                  children: [
                    StyledButton.medium(
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
          ],
        ),
      ),
    );
  }
}
