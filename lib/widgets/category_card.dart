import 'package:flutter/material.dart';

/// Card that shows a category with children inside. Can be set to be expandable.
class CategoryCard extends StatelessWidget {
  /// The category name.
  final String category;

  /// The leading icon to display.
  final Widget leading;

  /// The children inside this category.
  final List<Widget> children;

  /// Whether the category can expand and collapse.
  final bool canCollapse;

  const CategoryCard({
    Key key,
    @required this.category,
    @required this.leading,
    @required this.children,
    this.canCollapse: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          if (canCollapse)
            ExpansionTile(
              title: Text(category),
              leading: leading,
              children: children,
              initiallyExpanded: true,
            ),
          if (!canCollapse) ...[
            ListTile(
              title: Text(category),
              leading: leading,
            ),
            ...children,
          ]
        ],
      ),
    );
  }
}
