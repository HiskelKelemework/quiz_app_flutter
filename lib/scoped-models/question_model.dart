import 'package:scoped_model/scoped_model.dart';

import '../models/question.dart';

enum QuestionBankState { notLoaded, loaded, failed }

class QuestionModel extends Model {
  List<Question> _questions = [];
  var _currentQuestionIndex = 0;

  var questionBankState = QuestionBankState.notLoaded;

  int get numberOfQuestions {
    return _questions.length;
  }

  int get currentQuestionIndex {
    return _currentQuestionIndex;
  }

  Question get currentQuestion {
    return _questions[_currentQuestionIndex];
  }

  void incrementQuestionIndex() {
    _currentQuestionIndex += 1;
    notifyListeners();
  }

  void resetQuestionIndex() {
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  void addQuestions(List<Question> questions) {
    for (var question in questions) {
      _questions.add(question);
    }
    questionBankState = QuestionBankState.loaded;
  }
}
