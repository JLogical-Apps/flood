import 'package:example/style/test_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

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
                'This is a sample onboarding page with the $styleName theme. The logo above is just for sample purposes.'),
            header: Image.asset(
              'assets/logo_foreground.png',
              width: 400,
            ),
          ),
          OnboardingPageSection(
            title: StyledTitleText('Features'),
            description: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StyledContent.low(
                  header: 'This is some sample content.',
                  content: 'Test 123',
                  lead: StyledIcon(Icons.edit),
                  children: [
                    ButtonBar(
                      children: [
                        StyledButton.high(
                          text: 'High',
                          onTap: () {},
                        ),
                        StyledButton.medium(
                          text: 'Medium',
                          onTap: () {},
                        ),
                        StyledButton.low(
                          text: 'Low',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                ButtonBar(
                  children: [
                    StyledButton.high(
                      text: 'High',
                      onTap: () {},
                    ),
                    StyledButton.medium(
                      text: 'Medium',
                      onTap: () {},
                    ),
                    StyledButton.low(
                      text: 'Low',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            header: StyledSubtitleText('Here is some Header text'),
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
