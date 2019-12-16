import 'package:flutter/material.dart';

class CharChangeNotifier extends ValueNotifier<int> {
  int lastChar;
  CharChangeNotifier(int char) : super(char) {
    lastChar = char;
  }

  setChar(int char) {
    lastChar = value;
    value = char;
  }
}
