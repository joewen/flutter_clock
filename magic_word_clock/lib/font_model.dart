import 'dart:math';

import 'char_matrix.dart';
import 'dot_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_to_path_maker/text_to_path_maker.dart';

class FontModel {
  PMFont font;
  final int size;

  int maxWidth = 0;
  int maxHeight = 0;

  FontModel(this.size);

  Future<bool> initialize() async {
    if (font != null) {
      return false;
    }

    var data = await rootBundle.load("third_party/NotoSansDisplay-Regular.ttf");
    var reader = PMFontReader();

    font = reader.parseTTFAsset(data);
    return true;
  }

  CharMovement getDotPath(int fromChar, int toChar) {
    var from = getCharDots(fromChar);
    var to = getCharDots(toChar);

    var fromPoints = from.points.toList();
    fromPoints.shuffle();

    var toPoints = to.points.toList();
    toPoints.shuffle();

    var count = from.points.length > to.points.length
        ? from.points.length
        : to.points.length;

    var result = List<DotPath>();
    for (var i = 0; i < count; i++) {
      result.add(DotPath(
          fromPoints[i % fromPoints.length], toPoints[i % toPoints.length]));
    }

    return CharMovement(from, to, result);
  }

  CharMatrix getCharDots(int char) {
    var path = font.generatePathForCharacter(char);
    var bound = path.getBounds();
    var ratio = 0.0;

    if (bound.width > bound.height) {
      ratio = size / bound.width;
    } else {
      ratio = size / bound.height;
    }

    path = PMTransform.moveAndScale(path, 0.0, 0.0, ratio, ratio);
    return _convertPathToMatrix(path);
  }

  CharMatrix _convertPathToMatrix(Path path) {
    var bound = path.getBounds();

    var width = bound.width.ceil();
    if (width > maxWidth) {
      maxWidth = width;
    }

    var height = bound.height.ceil();
    if (height > maxHeight) {
      maxHeight = height;
    }

    var offsetX = 0;
    var offsetY = 0;

    if (bound.width > bound.height) {
      offsetY = ((maxHeight - height) / 2).ceil();
    } else {
      offsetX = ((maxWidth - width) / 2).ceil();
    }

    var dots = List<Point<int>>();

    for (var i = 0; i <= width; i++) {
      for (var j = 0; j <= height; j++) {
        if (path.contains(Offset(i + bound.left + 0.5, j + bound.top + 0.5))) {
          dots.add(Point<int>(i + offsetX, j + offsetY));
        }
      }
    }

    return CharMatrix(dots, maxWidth, maxHeight);
  }
}
