import 'package:firebase_realtime_trial/pages/question_category_page.dart';
import 'package:firebase_realtime_trial/scoped-models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/question_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<QuestionModel>(
      model: QuestionModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Basics',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: QuestionPage(),
        home: QuestionCategory(),
      ),
    );
  }
}
