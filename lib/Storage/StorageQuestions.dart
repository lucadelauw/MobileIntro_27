import 'package:mobileintro/Questions.dart';
import 'package:mobileintro/TeacherPages/GradeQuestions.dart';

abstract class QuestionStorage {
  int questionNumber;
  String question;
  List<Map<String, dynamic>> answers= [];
  double maxGrade;

  QuestionStorage(this.questionNumber, this.question, this.answers, this.maxGrade);

  toQuestion(int studentNumber);
  toQuestionTeacher();
  QuestionGrade toGradeQuestion(int studentNumber);
}

class OpenQuestionStorage extends QuestionStorage {
  String answer;

  OpenQuestionStorage(int questionNumber, String question, this.answer, List<Map<String, dynamic>> answers, double maxGrade) :
        super(questionNumber, question, answers, maxGrade);

  @override
  toQuestion(int studentNumber) {
    String? currentAnswer;
    if (answers.where((element) => (element['number'] == studentNumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentNumber))['answer'];
    }
    return OpenQuestion(questionNumber, question, studentNumber, answer, currentAnswer);
  }
  @override
  toQuestionTeacher() {
    return OpenQuestion(questionNumber, question, 0, answer, "");
  }

  @override
  QuestionGrade toGradeQuestion(int studentNumber) {
    String? currentAnswer;
    if (answers.where((element) => (element['number'] == studentNumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentNumber))['answer'];
    }
    return OpenGrade(question, answer, currentAnswer, maxGrade);
  }
}
class MultipleChoiceQuestionStorage extends QuestionStorage {

  List<String> input;
  int answer;

  MultipleChoiceQuestionStorage(int questionNumber, String question, this.input, this.answer, List<Map<String, dynamic>> answers, double maxGrade) :
        super(questionNumber, question, answers, maxGrade);

  @override
  toQuestion(int studentNumber) {
    int? currentAnswer;
    if (answers.where((element) => (element['number'] == studentNumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentNumber))['answer'];
    }
    return MultipleChoiceQuestion(questionNumber, question, studentNumber, input, answer, currentAnswer);
  }
  @override
  toQuestionTeacher() {
    return MultipleChoiceQuestion(questionNumber, question, 0, input, answer, 0);
  }

  @override
  QuestionGrade toGradeQuestion(int studentNumber) {
    int? currentAnswer;
    if (answers.where((element) => (element['number'] == studentNumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentNumber))['answer'];
    }
    return MultipleChoiceGrade(question, input, answer, currentAnswer, maxGrade);
  }
}
class CodeCorrectionQuestionStorage extends QuestionStorage {

  String input;
  String answer;

  CodeCorrectionQuestionStorage(int questionNumber, String question, this.input, this.answer, List<Map<String, dynamic>> answers, double maxGrade) :
        super(questionNumber, question, answers, maxGrade);

  @override
  toQuestion(int studentNumber) {
    String? currentAnswer;
    if (answers.where((element) => (element['number'] == studentNumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentNumber))['answer'];
    }
    return CodeCorrectionQuestion(questionNumber, question, studentNumber, input, answer, currentAnswer);
  }
  @override
  toQuestionTeacher() {
    return CodeCorrectionQuestion(questionNumber, question, 0, input, answer, "");
  }

  @override
  QuestionGrade toGradeQuestion(int studentNumber) {
    String? currentAnswer;
    if (answers.where((element) => (element['number'] == studentNumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentNumber))['answer'];
    }
    return CodeCorrectionGrade(question, input, answer, currentAnswer, maxGrade);
  }
}