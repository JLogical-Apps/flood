import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:url_launcher/url_launcher.dart';

/// Card that shows navigation.
class NavigationCard extends StatelessWidget {
  /// The title of the navigation card.
  final String title;

  /// The description for the navigation card.
  final String description;

  /// The icon to show in front.
  final IconData icon;

  /// The background color for the navigation card.
  final Color color;

  /// Action to perform when tapped.
  VoidCallback onTap;

  /// Whether the link is external. This will render the trailing icon differently.
  final bool isExternalLink;

  NavigationCard({
    Key key,
    @required this.title,
    @required this.onTap,
    this.description,
    this.icon,
    this.color: Colors.white,
    this.isExternalLink: false,
  }) : super(key: key);

  /// Creates a navigation card to open up the given [url].
  NavigationCard.url({
    Key key,
    @required this.title,
    @required String url,
    this.description,
    this.icon,
    this.color: Colors.white,
    this.isExternalLink: true,
  }) : super(key: key) {
    onTap = () async {
      if (await canLaunch(url)) {
        launch(url);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(
          title,
          style: useWhiteForeground(color, bias: 1.5) ? Theme.of(context).primaryTextTheme.bodyText1 : Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: description == null
            ? null
            : Text(
                description,
                style: useWhiteForeground(color, bias: 1.5) ? Theme.of(context).primaryTextTheme.bodyText2 : Theme.of(context).textTheme.bodyText2,
              ),
        leading: Icon(
          icon,
          color: useWhiteForeground(color, bias: 1.5) ? Theme.of(context).primaryIconTheme.color : Theme.of(context).iconTheme.color,
        ),
        trailing: isExternalLink
            ? Icon(
                Icons.exit_to_app,
                color: useWhiteForeground(color, bias: 1.5) ? Theme.of(context).primaryIconTheme.color : Theme.of(context).iconTheme.color,
              )
            : Icon(
                Icons.chevron_right,
                color: useWhiteForeground(color, bias: 1.5) ? Theme.of(context).primaryIconTheme.color : Theme.of(context).iconTheme.color,
              ),
        onTap: onTap,
      ),
    );
  }
}
