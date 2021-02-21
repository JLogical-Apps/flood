import 'package:flutter/material.dart';

/// Card that shows a category with children inside. Can be set to be expandable.
class CategoryCard extends StatelessWidget {
  /// The category name.
  final Widget category;

  /// The leading icon to display.
  final Widget leading;

  /// The trailing widget to display. Will replace the expansion widget if [canCollapse] is true.
  final Widget trailing;

  /// The children inside this category.
  final List<Widget> children;

  /// Whether the category can expand and collapse.
  final bool canCollapse;

  /// Whether the card is initially collapsed if it [canCollapse].
  final bool initiallyCollapsed;

  const CategoryCard({
    Key key,
    @required this.category,
    @required this.leading,
    this.trailing,
    @required this.children,
    this.canCollapse: false,
    this.initiallyCollapsed: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          if (canCollapse)
            ExpansionTile(
              title: DefaultTextStyle(
                style: Theme.of(context).textTheme.subtitle1,
                child: category,
              ),
              leading: IconTheme(
                child: leading,
                data: IconThemeData(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              trailing: trailing,
              children: children,
              initiallyExpanded: !initiallyCollapsed,
            ),
          if (!canCollapse) ...[
            ListTile(
              title: DefaultTextStyle(
                style: Theme.of(context).textTheme.subtitle1,
                child: category,
              ),
              leading: IconTheme(
                child: leading,
                data: IconThemeData(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              trailing: trailing,
            ),
            ...children,
          ]
        ],
      ),
    );
  }
}
