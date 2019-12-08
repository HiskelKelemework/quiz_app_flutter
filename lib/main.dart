import 'package:firebase_realtime_trial/pages/question_category_page.dart';
import 'package:firebase_realtime_trial/providers/question_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestionModel>(
      create: (context) => QuestionModel(),
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
