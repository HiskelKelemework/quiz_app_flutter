import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/question.dart';

enum ButtonState { check, proceed }

class QuestionWidget extends StatefulWidget {
  final Question question;
  final Function onNextClicked;

  QuestionWidget({@required this.question, @required this.onNextClicked});

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<QuestionWidget> {
  Map<int, bool> optionsState = Map();
  var buttonState = ButtonState.check;

  final disselectedColor = Color.fromRGBO(50, 50, 50, .2);
  final selectedColor = Color.fromRGBO(0, 150, 0, .5);

  Color _getAnswerOptionColor(int index) {
    if (buttonState == ButtonState.proceed) {
      if (widget.question.answerIndices.contains(index)) return Colors.green;
      return optionsState[index] ? Colors.red : disselectedColor;
    }
    return optionsState[index] ? selectedColor : disselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 20);

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
                        if (!widget.question.isMultipleChoice) {
                          for (var k in optionsState.keys) {
                            if (k != index) {
                              optionsState[k] = false;
                            }
                          }
                        }
                        optionsState[index] = !optionsState[index];
                      });
                    },
                    child: Container(
                      color: _getAnswerOptionColor(index),
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
            ),
            FlatButton(
              color: buttonState == ButtonState.check
                  ? Theme.of(context).primaryColor
                  : Colors.lightGreen,
              onPressed: buttonState == ButtonState.check
                  ? () {
                      // check clicked
                      setState(() {
                        buttonState = ButtonState.proceed;
                      });
                    }
                  : () {
                      // continue clicked
                      widget.onNextClicked();
                      setState(() {
                        optionsState = Map();
                        buttonState = ButtonState.check;
                      });
                    },
              textColor: Colors.white,
              child: Center(
                child: buttonState == ButtonState.check
                    ? Text('Check')
                    : Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
