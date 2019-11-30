import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;

  QuestionWidget({@required this.question});
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<QuestionWidget> {
  Map<int, bool> optionsState = Map();

  _QuestionState();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 20);
    const disselectedColor = Color.fromRGBO(50, 50, 50, .2);
    const selectedColor = Color.fromRGBO(0, 150, 0, .5);

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // the question
            Container(
              color: Theme.of(context).primaryColor.withOpacity(.3),
              padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
              margin: EdgeInsets.only(bottom: 8),
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.question.question,
                style: textStyle,
              ),
            ),
            // the answer options
            Expanded(
              child: ListView.builder(
                itemCount: widget.question.options.length,
                itemBuilder: (ctx, index) {
                  if (!optionsState.containsKey(index)) {
                    optionsState[index] = false;
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        optionsState[index] = !optionsState[index];
                      });
                    },
                    child: Container(
                      color: optionsState[index]
                          ? selectedColor
                          : disselectedColor,
                      padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                      margin: EdgeInsets.only(bottom: 8),
                      child: Text(
                        widget.question.options[index],
                        style: textStyle,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
