import 'dart:math';

import 'package:digital_clock/char_matrix.dart';

class DotPath {
  DotPath(this.start, this.end);
  final Point<int> start;
  final Point<int> end;
}

class CharMovement {
  CharMovement(this.oldChar, this.newChar, this.paths);
  final List<DotPath> paths;
  final CharMatrix oldChar;
  final CharMatrix newChar;
}
