import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A button that shows a menu when pressed.
class MenuButton extends StatelessWidget {
  final List<MenuItem> items;

  final Widget child;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final String? fontFamily;

  MenuButton({
    required this.items,
    this.child: const Padding(
      padding: EdgeInsets.all(8),
      child: Icon(Icons.more_vert),
    ),
    this.backgroundColor,
    this.foregroundColor,
    this.elevation: 0,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? SizedBox.shrink()
        : PopupMenuButton<String>(
            color: backgroundColor,
            child: child,
            elevation: elevation,
            itemBuilder: (context) => items
                .map((item) => PopupMenuItem<String>(
                      value: item.text,
                      child: ListTile(
                        title: Text(
                          item.text,
                          style: GoogleFonts.getFont(fontFamily ?? Theme.of(context).textTheme.button!.fontFamily!).copyWith(color: item.color),
                        ),
                        subtitle: item.description == null
                            ? null
                            : Text(
                                item.description!,
                                style: GoogleFonts.getFont(fontFamily ?? Theme.of(context).textTheme.button!.fontFamily!).copyWith(color: foregroundColor?.withOpacity(0.87) ?? Colors.black87),
                              ),
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

  const MenuItem(
      {required this.text, this.description, this.icon, this.color: Colors.black87, required this.onPressed});
}
