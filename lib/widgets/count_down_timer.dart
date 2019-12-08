import 'package:firebase_realtime_trial/providers/tick_provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

class CountDownTimer extends StatelessWidget {
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

  onCountDownReachedZero() {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctxt) => TickProvider(countDownFromMin, countDownFromSec,
          (Function resetTimer) {
        onCountDownFinish(resetTimer);
      }),
      child: Consumer<TickProvider>(
        builder: (context, model, child) {
          final min = model.min;
          final sec = model.sec;

          var time =
              "${(min < 10) ? '0$min' : min}:${(model.sec < 10) ? '0$sec' : sec}";

          return Container(
            padding: EdgeInsets.all(8),
            color: bgColor,
            decoration: boxDecoration,
            child: Center(
              child: Text(
                time,
                style: textStyle,
              ),
            ),
          );
        },
      ),
    );
  }
}
