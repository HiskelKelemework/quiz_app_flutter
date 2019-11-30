import 'package:flutter/widgets.dart';

class Question {
  final String question;
  final List<String> options;
  final List<int> answerIndices;
  final bool isMultipleChoice;

  Question({
    @required this.question,
    @required this.options,
    @required this.answerIndices,
    @required this.isMultipleChoice,
  });

  static Question fromMap(Map<String, dynamic> attr) {
    return Question(
        question: attr['question'],
        options: List.castFrom<dynamic, String>(attr['options']),
        answerIndices: List.castFrom<dynamic, int>(attr['answers']),
        isMultipleChoice: attr['is_multiple_choice']);
  }
}
