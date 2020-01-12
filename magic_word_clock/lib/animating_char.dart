import 'char_change_notifier.dart';
import 'char_painter.dart';
import 'package:flutter/material.dart';
import 'dot_path.dart';
import 'font_model.dart';

class AnimatingChar extends StatefulWidget {
  final FontModel fontModel;

  final double dotSize;
  final CharChangeNotifier notifier;

  AnimatingChar(this.fontModel, this.dotSize, {@required this.notifier});

  @override
  _AnimatingCharState createState() => _AnimatingCharState();
}

class _AnimatingCharState extends State<AnimatingChar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> tween;
  CharMovement movement;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    tween = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)
      ..addListener(() {
        setState(() {});
      }));
    charUpdated();
    widget.notifier?.addListener(charUpdated);
  }

  void charUpdated() {
    movement = widget.fontModel
        .getDotPath(widget.notifier.lastChar, widget.notifier.value);
    _controller.reset();
    _controller.forward();
  }

  @override
  dispose() {
    _controller?.dispose();
    widget.notifier?.removeListener(charUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dots = movement.paths.map((d) {
      var x = d.start.x + (d.end.x - d.start.x) * tween.value;
      var y = d.start.y + (d.end.y - d.start.y) * tween.value;
      return Offset(x, y);
    });

    return Container(
        child: Center(
            child: CustomPaint(
      size: Size(movement.newChar.width * widget.dotSize,
          movement.newChar.height * widget.dotSize),
      painter: CharPainter(dots.toList(), widget.dotSize),
    )));
  }
}
