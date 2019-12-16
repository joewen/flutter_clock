import 'package:flutter/material.dart';

class CharPainter extends CustomPainter {
  final List<Offset> dots;
  final double dotSize;

  CharPainter(this.dots, this.dotSize);

  @override
  void paint(Canvas canvas, Size size) {
    var rectPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Color.fromARGB(0xff, 0xfc, 0xbf, 0x49);

    var borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color.fromARGB(0xff, 0x00, 0x30, 0x49)
      ..strokeWidth = 0.5;

    dots.forEach((d) {
      var x = d.dx * dotSize;
      var y = d.dy * dotSize;

      canvas.drawRect(Rect.fromLTRB(x, y, x + dotSize, y + dotSize), rectPaint);

      canvas.drawRect(
          Rect.fromLTRB(x, y, x + dotSize, y + dotSize), borderPaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
