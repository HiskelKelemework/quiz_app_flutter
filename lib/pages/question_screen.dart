import 'package:firebase_realtime_trial/scoped-models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';

import '../widgets/score.dart';
import '../widgets/count_down_timer.dart';
import '../widgets/question.dart';

import '../models/question.dart';

class QuestionPage extends StatefulWidget {
  final String questionType;
  QuestionPage(this.questionType);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  var timeMin = 0;
  var timeSec = 10;

  void onNextClicked(QuestionModel model) {
    if (model.currentQuestionIndex < model.numberOfQuestions - 1) {
      model.incrementQuestionIndex();
    } else {
      // finished displaying the questions, show perhaps a pop up showing summary.
      model.resetQuestionIndex();
    }
  }

  void onCountDownFinish(Function resetQuestionIndex) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time is up!'),
          content: const Text('You did not finish in time.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Quit'),
              onPressed: () {},
            ),
            FlatButton(
              child: Text('Start over'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                resetQuestionIndex();
                setState(() {
                  timeMin = 0;
                  timeSec = 10;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestions(QuestionModel model) {
    return Container(
      padding: const EdgeInsets.only(top: 32, bottom: 32, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Score(
                  fullProgressCount: model.numberOfQuestions,
                  progressCount: model.currentQuestionIndex + 1,
                ),
                CountDownTimer(
                  countDownFromMin: timeMin,
                  countDownFromSec: timeSec,
                  textStyle: TextStyle(fontSize: 20),
                  onCountDownFinish: () =>
                      this.onCountDownFinish(model.resetQuestionIndex),
                ),
                QuestionWidget(
                  question: model.currentQuestion,
                  onNextClicked: () => this.onNextClicked(model),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetry(Function renewFetcher) {
    return Center(
      child: FlatButton(
        color: Colors.blue,
        child: Text('Retry'),
        onPressed: () {
          renewFetcher();
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(
              'Fetching questions, please wait',
              style: TextStyle(fontSize: 18),
            ),
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: ScopedModelDescendant<QuestionModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, Widget child, QuestionModel model) {
          return FutureBuilder<dynamic>(
            future: model.questionFetcher,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('did not start');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return _buildLoadingIndicator();
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return _buildRetry(model.renewQuestionFetcher);
                  }

                  // only add the questions once.
                  if (model.questionBankState == QuestionBankState.notLoaded) {
                    final Map<String, dynamic> data =
                        json.decode((snapshot.data as http.Response).body);

                    final List<Question> questions = [];

                    data.forEach((String k, dynamic v) {
                      questions
                          .add(Question.fromMap(v as Map<String, dynamic>));
                    });
                    model.addQuestions(questions);
                  }

                  return _buildQuestions(model);
              }
              return null; // will never reach here
            },
          );
        },
      ),
    );
  }
}
