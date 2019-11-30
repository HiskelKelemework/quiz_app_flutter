import 'package:flutter/cupertino.dart';
import 'dart:async';

class CountDownTimer extends StatefulWidget {
  final int countDownFromMin;
  final int countDownFromSec;

  final Function onCountDownFinish;

  final BoxDecoration boxDecoration;
  final TextStyle textStyle;
  final Color bgColor;

  CountDownTimer({
    @required this.countDownFromMin,
    @required this.countDownFromSec,
    @required this.onCountDownFinish,
    this.boxDecoration,
    this.textStyle,
    this.bgColor,
  });

  @override
  _CountDownTimerState createState() =>
      _CountDownTimerState(min: countDownFromMin, sec: countDownFromSec);
}

class _CountDownTimerState extends State<CountDownTimer> {
  int min, sec;
  _CountDownTimerState({this.min, this.sec});

  Timer _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          sec -= 1;

          if (sec == 0 && min == 0) {
            _timer.cancel();
            // callback here if needed
            widget.onCountDownFinish();
          }

          if (sec == -1 && min > 0) {
            sec = 59;
            min -= 1;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var time = "${(min < 10) ? '0$min' : min}:${(sec < 10) ? '0$sec' : sec}";
    return Container(
      padding: EdgeInsets.all(8),
      color: widget.bgColor,
      decoration: widget.boxDecoration,
      child: Center(
        child: Text(
          time,
          style: widget.textStyle,
        ),
      ),
    );
  }
}
