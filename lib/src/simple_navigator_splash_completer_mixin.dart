import 'dart:async';

import 'package:flutter/material.dart';

mixin SimpleNavigatorSplashCompleterMixin on StatefulWidget {
  final _completer = Completer();

  Future<void> get wait => _completer.future;

  void complete() {
    _completer.complete();
  }
}
