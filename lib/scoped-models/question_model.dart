import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/question.dart';

enum QuestionBankState { notLoaded, loaded, failed }

class QuestionModel extends Model {
  Map<String, List<Question>> _questions = {};
  var _currentQuestionIndex = 0;

  var questionBankState = QuestionBankState.notLoaded;
  Future _questionFetcher;
  String _selectedCategory;

  Future getQuestionFetcher() => http
      .get('https://mobile-development-52de3.firebaseio.com/questions.json');

  Future get questionFetcher {
    if (_questionFetcher == null) {
      _questionFetcher = getQuestionFetcher();
    }
    return _questionFetcher;
  }

  set selectedCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      _questionFetcher = getQuestionFetcher();
      questionBankState = QuestionBankState.notLoaded;
      notifyListeners();
    }
  }

  renewQuestionFetcher() {
    _questionFetcher = http
        .get('https://mobile-development-52de3.firebaseio.com/questions.json');
    notifyListeners();
  }

  int get numberOfQuestions {
    return _questions[_selectedCategory].length;
  }

  int get currentQuestionIndex {
    return _currentQuestionIndex;
  }

  Question get currentQuestion {
    return _questions[_selectedCategory][_currentQuestionIndex];
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
    if (!_questions.containsKey(_selectedCategory)) {
      _questions[_selectedCategory] = [];
    }

    for (var question in questions) {
      _questions[_selectedCategory].add(question);
    }
    questionBankState = QuestionBankState.loaded;
  }
}
