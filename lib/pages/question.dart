import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/score.dart';
import '../widgets/count_down_timer.dart';
import '../widgets/question.dart';

import '../models/question.dart';

enum QuestionBankState { notLoaded, loaded, failed }

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  var currentQuestionIndex = 0;
  var questionBankState = QuestionBankState.notLoaded;
  List<Question> questions = [];

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

  void onNextClicked() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex += 1;
      });
    } else {
      // finished displaying the questions, show perhaps a pop up showing summary.
      print('went through the questions');
    }
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
                          progressCount: currentQuestionIndex + 1,
                        ),
                        CountDownTimer(
                          countDownFromMin: 2,
                          countDownFromSec: 35,
                          textStyle: TextStyle(fontSize: 20),
                          onCountDownFinish: () => {},
                        ),
                        QuestionWidget(
                          question: questions[currentQuestionIndex],
                          onNextClicked: this.onNextClicked,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
