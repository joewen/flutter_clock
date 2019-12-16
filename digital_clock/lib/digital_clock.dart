// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/animating_char.dart';
import 'package:digital_clock/char_change_notifier.dart';
import 'package:digital_clock/font_model.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;
  final double horizontalPadding = 40;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  final FontModel fontModel = FontModel(20);

  final List<CharChangeNotifier> notifiers = List<CharChangeNotifier>();

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _initializeNotifier();
    _updateTime();
    _updateModel();
  }

  void _initializeNotifier() {
    var str = _getTimeString();
    for (var i = 0; i < str.length; i++) {
      notifiers.add(CharChangeNotifier(str.codeUnitAt(i)));
    }
  }

  String _getTimeString() => DateFormat('HH:mm:ss').format(_dateTime);

  void _updateNotitier() {
    var str = _getTimeString();
    for (var i = 0; i < str.length; i++) {
      notifiers[i].setChar(str.codeUnitAt(i));
    }
  }

  void _disposeNotifier() {
    for (var i = 0; i < notifiers.length; i++) {
      notifiers[i].dispose();
    }
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    _disposeNotifier();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _updateNotitier();

      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - widget.horizontalPadding;
    var dotSize = (width / fontModel.size / notifiers.length).toDouble();

    return FutureBuilder<bool>(
      future: fontModel.initialize(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            color: Color.fromARGB(0xff, 0x00, 0x30, 0x49),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: notifiers
                  .map((n) => Expanded(
                          child: Container(
                        child: AnimatingChar(fontModel, dotSize, notifier: n),
                      )))
                  .toList(),
            ),
          );
        } else {
          return Container(
            color: Colors.black,
          );
        }
      },
    );
  }
}
