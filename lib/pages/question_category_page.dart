import 'package:firebase_realtime_trial/pages/question_screen.dart';
import 'package:firebase_realtime_trial/providers/question_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionCategory extends StatelessWidget {
  final _categories = [
    {'title': 'Programming', 'color': Colors.green},
    {'title': 'Mathematics', 'color': Colors.purple},
    {'title': 'Physics', 'color': Colors.red},
    {'title': 'Philosophy', 'color': Colors.blue},
    {'title': 'General Knowledge', 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white, fontSize: 25);

    return Consumer<QuestionModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Categories'),
          ),
          body: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final title = _categories[index]['title'];
              final color = _categories[index]['color'];

              return GestureDetector(
                onTap: () {
                  model.selectedCategory = title;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuestionPage(title)));
                },
                child: Container(
                    height: 200,
                    padding: const EdgeInsets.only(bottom: 8),
                    color: color,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        title,
                        style: textStyle,
                      ),
                    )),
              );
            },
          ),
        );
      },
    );
  }
}
