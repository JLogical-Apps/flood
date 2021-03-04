import 'package:flutter/material.dart';

/// A button that shows a menu when pressed.
class MenuButton extends StatelessWidget {
  final List<MenuItem> items;

  final Widget child;

  MenuButton({
    required this.items,
    this.child: const Padding(
      padding: EdgeInsets.all(8),
      child: Icon(Icons.more_vert),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? SizedBox.shrink()
        : PopupMenuButton<String>(
            child: child,
            itemBuilder: (context) => items
                .map((item) => PopupMenuItem<String>(
                      value: item.text,
                      child: ListTile(
                        title: Text(item.text),
                        subtitle: item.description == null ? null : Text(item.description!),
                        leading: item.icon != null
                            ? Icon(
                                item.icon,
                                color: item.color,
                              )
                            : null,
                        onTap: () {
                          Navigator.of(context).pop();
                          item.onPressed();
                        },
                      ),
                    ))
                .toList(),
            onSelected: (value) {},
          );
  }
}

class MenuItem {
  final String text;
  final String? description;
  final IconData? icon;
  final Color color;
  final Function onPressed;

  const MenuItem({required this.text, this.description, this.icon, this.color: Colors.black87, required this.onPressed});
}
