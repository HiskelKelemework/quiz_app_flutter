import 'dart:async';

import 'package:flutter/foundation.dart';

class TickProvider with ChangeNotifier {
  final int _min, _sec;
  int _mMin, _mSec;
  Timer _timer;

  Function(Function onResetRequest) _onCountDownFinish;

  get min => _mMin;
  get sec => _mSec;

  TickProvider(this._min, this._sec, this._onCountDownFinish) {
    _mMin = _min;
    _mSec = _sec;
    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
  }

  _onTick(timer) {
    _mSec -= 1;

    if (_mSec == 0 && _mMin == 0) {
      timer.cancel();
      _onCountDownFinish(resetTicker);
    }

    if (_sec == -1 && _min > 0) {
      _mSec = 59;
      _mMin -= 1;
    }
    notifyListeners();
  }

  resetTicker() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _mSec = _sec;
    _mMin = _min;
    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    notifyListeners();
  }
}
