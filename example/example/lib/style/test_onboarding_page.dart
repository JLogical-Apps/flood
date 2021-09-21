import 'package:example/style/test_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:tinycolor2/tinycolor2.dart';

class TestOnboardingPage extends HookWidget {
  final Style style;

  final String styleName;

  TestOnboardingPage({Key? key, required this.style, required this.styleName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkboxValue = useState(false);
    final date = useState(DateTime.now());
    final favoriteFood = useState('Pizza');
    final gender = useState('male');

    return StyleProvider(
      style: style,
      child: StyledOnboardingPage(
        sections: [
          OnboardingPageSection(
            titleText: styleName,
            bodyText:
                'This is a sample onboarding page with the $styleName theme. The logo above is just for sample purposes. Scroll through to see a demo of the style.',
            header: Image.asset(
              'assets/logo_foreground.png',
              width: 400,
            ),
          ),
          OnboardingPageSection(
            headerIcon: Icons.text_fields,
            titleText: 'Text',
            body: ScrollColumn.withScrollbar(
              children: [
                StyledBodyText(
                    'There are a couple different types of texts to choose from. Texts will adapt their color based on the background they are on.'),
                StyledDivider(),
                StyledTitleText('Title'),
                StyledSubtitleText('Subtitle'),
                StyledContentHeaderText('Content Header'),
                StyledContentSubtitleText('Content Subtitle'),
                StyledBodyText('Body'),
                StyledButtonText('Button'),
                StyledDivider(),
                StyledContent.high(
                  headerText: 'Text in vibrant background',
                  children: [
                    StyledTitleText('Title'),
                    StyledSubtitleText('Subtitle'),
                    StyledContentHeaderText('Content Header'),
                    StyledContentSubtitleText('Content Subtitle'),
                    StyledBodyText('Body'),
                    StyledButtonText('Button'),
                  ],
                ),
                StyledDivider(),
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
          ),
          OnboardingPageSection(
            headerIcon: Icons.smart_button,
            titleText: 'Buttons',
            body: ScrollColumn.withScrollbar(
              children: [
                StyledBodyText('Buttons determine their colors based on an emphasis.'),
                StyledDivider(),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StyledButton.high(text: 'High', onTapped: () {}),
                    StyledButton.medium(text: 'Med', onTapped: () {}),
                    StyledButton.low(text: 'Low', onTapped: () {}),
                  ],
                ),
                StyledContent.high(
                  headerText: 'Buttons in vibrant background',
                  children: [
                    ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StyledButton.high(text: 'High', onTapped: () {}),
                        StyledButton.medium(text: 'Med', onTapped: () {}),
                        StyledButton.low(text: 'Low', onTapped: () {}),
                      ],
                    ),
                  ],
                ),
                StyledDivider(),
                StyledBodyText('Buttons can have icons and have custom colors as well.'),
                StyledButton.high(
                  text: 'Delete',
                  color: Colors.red.darken(30),
                  icon: Icons.delete,
                  onTapped: () {},
                ),
                StyledButton.medium(
                  text: 'Save',
                  color: Colors.blue.darken(30),
                  icon: Icons.save,
                  onTapped: () {},
                ),
                StyledButton.low(
                  text: 'Cancel',
                  color: Colors.orange,
                  icon: Icons.exit_to_app,
                  onTapped: () {},
                ),
              ],
            ),
          ),
          OnboardingPageSection(
            headerIcon: Icons.article,
            titleText: 'Content',
            body: ScrollColumn.withScrollbar(
              children: [
                StyledBodyText('Content essentially is a container that holds data about... something.'),
                StyledBodyText('Like buttons, Contents also change their appearance based on their emphasis.'),
                StyledDivider(),
                StyledContent.low(
                  headerText: 'Entertainment',
                  bodyText: '\$25.24',
                ),
                StyledContent.high(
                  headerText: 'Budget Summary',
                  bodyText: 'Total Amount: \$592.42',
                  children: [
                    StyledBodyText('This is a child of the content'),
                    StyledContent.low(
                      headerText: 'Envelopes',
                      bodyText: '4',
                      leading: StyledIcon(Icons.mail),
                    ),
                    StyledContent.low(
                      headerText: 'Transactions Last Month',
                      bodyText: '41',
                      leading: StyledIcon(Icons.show_chart),
                    ),
                  ],
                  onTapped: () {
                    print('You clicked me!');
                  },
                ),
                StyledDivider(),
                StyledBodyText('Content can also have actions associated with them.'),
                StyledContent.low(
                  headerText: 'Insurance',
                  bodyText: '\$82.02',
                  actions: [
                    ActionItem(
                      name: 'Edit',
                      description: 'Edit the envelope.',
                      color: Colors.orange,
                      leading: StyledIcon(Icons.edit),
                      onPerform: () {
                        print('This does not actually do anything.');
                      },
                    )
                  ],
                  onTapped: () {
                    print('You clicked me!');
                  },
                ),
              ],
            ),
          ),
          OnboardingPageSection(
            headerIcon: Icons.list_alt,
            titleText: 'Categories',
            body: ScrollColumn.withScrollbar(
              children: [
                StyledBodyText(
                    'Categories are a container for a group of Contents, or any other Widgets. They help visualize a specific group of related widgets.'),
                StyledDivider(),
                StyledCategory.low(
                  headerText: 'Todo List',
                  children: [
                    StyledContent.low(headerText: 'Item 1'),
                    StyledContent.low(headerText: 'Item 2'),
                    StyledContent.low(headerText: 'Item 3'),
                  ],
                ),
                StyledDivider(),
                StyledCategory.medium(
                  headerText: 'Todo List',
                  bodyText: 'Your list of todos to complete by the end of today.',
                  children: [
                    StyledContent.low(headerText: 'Item 1'),
                    StyledContent.low(headerText: 'Item 2'),
                    StyledContent.low(headerText: 'Item 3'),
                  ],
                ),
                StyledDivider(),
                StyledCategory.high(
                  headerText: 'Todo List',
                  leading: StyledIcon(Icons.check_outlined),
                  actions: [
                    ActionItem(
                      name: 'Complete All',
                    ),
                  ],
                  children: [
                    StyledContent.low(headerText: 'Item 1'),
                    StyledContent.low(headerText: 'Item 2'),
                    StyledContent.low(headerText: 'Item 3'),
                  ],
                ),
                StyledCategory.high(
                  headerText: 'Grid',
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      children: [
                        StyledContent.low(headerText: 'Item 1'),
                        StyledContent.low(headerText: 'Item 2'),
                        StyledContent.low(headerText: 'Item 3'),
                      ],
                      childAspectRatio: 100 / 50,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OnboardingPageSection(
            headerIcon: Icons.extension,
            titleText: 'Other',
            body: ScrollColumn.withScrollbar(
              children: [
                StyledBodyText('Here are some other styled widgets as well.'),
                StyledDivider(),
                StyledTextField(
                  label: 'Name',
                  initialText: 'John Doe',
                ),
                StyledDivider(),
                StyledCategory.high(
                  children: [
                    StyledTextField(
                      label: 'Name',
                      initialText: 'John Doe',
                    ),
                  ],
                ),
                StyledDivider(),
                StyledCheckbox(
                  label: 'Accept Terms and Conditions',
                  value: checkboxValue.value,
                  onChanged: (value) => checkboxValue.value = value,
                ),
                StyledDivider(),
                StyledCategory.high(
                  children: [
                    StyledCheckbox(
                      label: 'Accept Terms and Conditions',
                      value: checkboxValue.value,
                      onChanged: (value) => checkboxValue.value = value,
                    ),
                  ],
                ),
                StyledDivider(),
                StyledDateField(
                  label: 'Date',
                  date: DateTime.now(),
                  onChanged: (value) => date.value = value,
                ),
                StyledDivider(),
                StyledCategory.high(
                  children: [
                    StyledDateField(
                      label: 'Date',
                      date: DateTime.now(),
                      onChanged: (value) => date.value = value,
                    ),
                  ],
                ),
                StyledDivider(),
                StyledDropdown<String>(
                  label: 'Favorite Food',
                  value: 'Pizza',
                  options: ['Pizza', 'Ice Cream', 'Soggy Waffles'],
                  onChanged: (value) => favoriteFood.value = value!,
                ),
                StyledDivider(),
                StyledCategory.high(
                  children: [
                    StyledDropdown<String>(
                      label: 'Favorite Food',
                      value: 'Pizza',
                      options: ['Pizza', 'Ice Cream', 'Soggy Waffles'],
                      onChanged: (value) => favoriteFood.value = value!,
                    ),
                  ],
                ),
                StyledDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StyledRadio<String>(
                      label: 'Male',
                      radioValue: 'male',
                      groupValue: gender.value,
                      onChanged: (value) => gender.value = value,
                    ),
                    StyledRadio<String>(
                      label: 'Female',
                      radioValue: 'female',
                      groupValue: gender.value,
                      onChanged: (value) => gender.value = value,
                    ),
                  ],
                ),
                StyledDivider(),
                StyledCategory.high(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StyledRadio<String>(
                          label: 'Male',
                          radioValue: 'male',
                          groupValue: gender.value,
                          onChanged: (value) => gender.value = value,
                        ),
                        StyledRadio<String>(
                          label: 'Female',
                          radioValue: 'female',
                          groupValue: gender.value,
                          onChanged: (value) => gender.value = value,
                        ),
                      ],
                    ),
                  ],
                ),
                StyledDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StyledChip.low(
                      text: 'Low',
                    ),
                    StyledChip.medium(
                      text: 'Medium',
                    ),
                    StyledChip.high(
                      text: 'High',
                    ),
                  ],
                ),
                StyledDivider(),
                StyledCategory.high(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StyledChip.low(
                          text: 'Low',
                        ),
                        StyledChip.medium(
                          text: 'Medium',
                        ),
                        StyledChip.high(
                          text: 'High',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        onComplete: () => style.navigateReplacement(context: context, newPage: (context) => TestHomePage(style: style)),
        onSkip: () => style.navigateReplacement(context: context, newPage: (context) => TestHomePage(style: style)),
      ),
    );
  }
}
