import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Score extends StatefulWidget {
  final int fullProgressCount;
  final int progressCount;

  Score({@required this.fullProgressCount, @required this.progressCount});

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LinearProgressIndicator(
          value: widget.progressCount / widget.fullProgressCount,
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          child: Center(
            child: Text('${widget.progressCount}/${widget.fullProgressCount}'),
          ),
        )
      ],
    );
  }
}
