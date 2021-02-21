import 'package:flutter/material.dart';

/// Button that invokes a future and becomes a circular progress button until it finishes.
class FutureButton extends StatefulWidget {
  /// The child of the button when not loading.
  final Widget child;

  /// Action to perform when pressed.
  final Future Function() onPressed;

  const FutureButton({@required this.child, @required this.onPressed});

  @override
  _FutureButtonState createState() => _FutureButtonState();
}

class _FutureButtonState extends State<FutureButton> {
  bool inFuture = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        onPressed: inFuture
            ? () {}
            : () async {
                setState(() => inFuture = true);
                await widget.onPressed();
                setState(() => inFuture = false);
              },
        child: AnimatedCrossFade(
          duration: Duration(milliseconds: 110),
          crossFadeState: inFuture ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: DefaultTextStyle(
            style: Theme.of(context).primaryTextTheme.button,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            maxLines: 1,
            child: widget.child,
          ),
          secondChild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
