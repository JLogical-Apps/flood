import 'package:example/style/test_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:tinycolor2/tinycolor2.dart';

class TestOnboardingPage extends StatelessWidget {
  final Style style;

  final String styleName;

  TestOnboardingPage({Key? key, required this.style, required this.styleName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyleProvider(
      style: style,
      child: StyledOnboardingPage(
        sections: [
          OnboardingPageSection(
            title: StyledTitleText(styleName),
            description: StyledBodyText(
                'This is a sample onboarding page with the $styleName theme. The logo above is just for sample purposes. Scroll through to see a demo of the style.'),
            header: Image.asset(
              'assets/logo_foreground.png',
              width: 400,
            ),
          ),
          OnboardingPageSection(
            title: StyledTitleText('Text'),
            description: ScrollColumn.withScrollbar(
              children: [
                StyledBodyText(
                    'There are a couple different types of texts to choose from. Texts will adapt their color based on the background they are on.'),
                Divider(),
                StyledTitleText('Title'),
                StyledSubtitleText('Subtitle'),
                StyledContentHeaderText('Content Header'),
                StyledContentSubtitleText('Content Subtitle'),
                StyledBodyText('Body'),
                StyledButtonText('Button'),
                Divider(),
                StyledContent.high(
                  header: 'Text in vibrant background',
                  children: [
                    StyledTitleText('Title'),
                    StyledSubtitleText('Subtitle'),
                    StyledContentHeaderText('Content Header'),
                    StyledContentSubtitleText('Content Subtitle'),
                    StyledBodyText('Body'),
                    StyledButtonText('Button'),
                  ],
                ),
                Divider(),
                StyledBodyText('You can also perform overrides to text to have complete customization of it.'),
                StyledBodyText(
                  'I am big and italic even though I am a body text.',
                  textOverrides: StyledTextOverrides(
                    letterSpacing: 5,
                    fontWeight: FontWeight.w100,
                    textAlign: TextAlign.right,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
            header: StyledIcon(
              Icons.text_fields,
              size: 40,
            ),
          ),
          OnboardingPageSection(
            title: StyledTitleText('Buttons'),
            description: ScrollColumn.withScrollbar(
              children: [
                StyledBodyText('Buttons determine their colors based on an emphasis.'),
                Divider(),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StyledButton.high(text: 'High', onTap: () {}),
                    StyledButton.medium(text: 'Med', onTap: () {}),
                    StyledButton.low(text: 'Low', onTap: () {}),
                  ],
                ),
                StyledContent.high(
                  header: 'Buttons in vibrant background',
                  children: [
                    ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StyledButton.high(text: 'High', onTap: () {}),
                        StyledButton.medium(text: 'Med', onTap: () {}),
                        StyledButton.low(text: 'Low', onTap: () {}),
                      ],
                    ),
                  ],
                ),
                Divider(),
                StyledBodyText('Buttons can have icons and have custom colors as well.'),
                StyledButton.high(
                  text: 'Delete',
                  color: Colors.red.darken(30),
                  icon: Icons.delete,
                  onTap: () {},
                ),
                StyledButton.medium(
                  text: 'Save',
                  color: Colors.blue.darken(30),
                  icon: Icons.save,
                  onTap: () {},
                ),
                StyledButton.low(
                  text: 'Cancel',
                  color: Colors.orange,
                  icon: Icons.exit_to_app,
                  onTap: () {},
                ),
              ],
            ),
            header: StyledIcon(
              Icons.smart_button,
              size: 40,
            ),
          ),
          OnboardingPageSection(
            title: StyledTitleText('Content'),
            description: ScrollColumn.withScrollbar(
              children: [
                StyledBodyText('Content essentially is a container that holds data about... something.'),
                StyledBodyText('Like buttons, Contents also change their appearance based on their emphasis.'),
                Divider(),
                StyledContent.low(
                  header: 'Entertainment',
                  content: '\$25.24',
                ),
                StyledContent.high(
                  header: 'Budget Summary',
                  content: 'Total Amount: \$592.42',
                  children: [
                    StyledBodyText('This is a child of the content'),
                    StyledContent.low(
                      header: 'Envelopes',
                      content: '4',
                      lead: StyledIcon(Icons.mail),
                    ),
                    StyledContent.low(
                      header: 'Transactions Last Month',
                      content: '41',
                      lead: StyledIcon(Icons.show_chart),
                    ),
                  ],
                  onTap: () {
                    print('You clicked me!');
                  },
                ),
                Divider(),
                StyledBodyText('Content can also have actions associated with them.'),
                StyledContent.low(
                  header: 'Insurance',
                  content: '\$82.02',
                  actions: [
                    ActionItem(
                      name: 'Edit',
                      description: 'Edit the envelope.',
                      color: Colors.orange,
                      lead: StyledIcon(Icons.edit),
                      onPerform: () {
                        print('This does not actually do anything.');
                      },
                    )
                  ],
                  onTap: () {
                    print('You clicked me!');
                  },
                ),
              ],
            ),
            header: StyledIcon(
              Icons.article,
              size: 40,
            ),
          ),
        ],
        onComplete: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => TestHomePage(
                    style: style,
                  )));
        },
        onSkip: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => TestHomePage(
                    style: style,
                  )));
        },
      ),
    );
  }
}
