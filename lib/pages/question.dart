import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/score.dart';
import '../widgets/count_down_timer.dart';
import '../widgets/question.dart';

import '../models/question.dart';

enum ButtonState { check, proceed }
enum QuestionBankState { notLoaded, loaded, failed }

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  var currentQuestionIndex = 0;
  var questionBankState = QuestionBankState.notLoaded;
  List<Question> questions = [];

  var buttonState = ButtonState.check;

  @override
  void initState() {
    _getQuestions();
    super.initState();
  }

  void _getQuestions() {
    const url =
        'https://mobile-development-52de3.firebaseio.com/questions.json';

    http.get(url).then((response) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<Question> _questions = [];

      data.forEach((String k, dynamic v) {
        _questions.add(Question.fromMap(v as Map<String, dynamic>));
      });

      setState(() {
        questions = _questions;
        questionBankState = QuestionBankState.loaded;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        questionBankState = QuestionBankState.failed;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: questionBankState != QuestionBankState.loaded
          ? questionBankState == QuestionBankState.notLoaded
              ? Center(child: Text('Fetching questions, please wait'))
              : Center(
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text('Retry'),
                    onPressed: () {
                      setState(() {
                        questionBankState = QuestionBankState.notLoaded;
                      });
                      _getQuestions();
                    },
                  ),
                )
          : Container(
              padding:
                  const EdgeInsets.only(top: 32, bottom: 32, left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Score(
                          fullProgressCount: questions.length,
                          progressCount: currentQuestionIndex,
                        ),
                        CountDownTimer(
                          countDownFromMin: 2,
                          countDownFromSec: 35,
                          textStyle: TextStyle(fontSize: 20),
                          onCountDownFinish: () => {},
                        ),
                        QuestionWidget(
                          question: questions[currentQuestionIndex],
                        )
                      ],
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
                            setState(() {
                              if (currentQuestionIndex ==
                                  questions.length - 1) {
                                // dummy-implementation, perhaps a popup here
                                currentQuestionIndex = 0;
                                buttonState = ButtonState.check;
                              } else {
                                this.currentQuestionIndex += 1;
                                buttonState = ButtonState.check;
                              }
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
