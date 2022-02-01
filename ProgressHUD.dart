import 'package:flutter/material.dart';
import 'package:merchandising/Constants.dart';

class ProgressHUD extends StatelessWidget {

  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color> valueColor;

  ProgressHUD({
    Key key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity,
    this.color = Colors.grey,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          new Center(
            child: new CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(orange),
            )
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}