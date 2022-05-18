import 'package:cloud_firestore/cloud_firestore.dart';
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
    double currentGrade = 0;
    GeoPoint? location;
    int timesGoneToBackground = 0;
    if (answers.where((element) => (element['number'] == studentNumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentNumber))['answer'];
      currentGrade = double.parse(answers.singleWhere((element) => (element['number'] == studentNumber))['currentGrade'].toString());
      location = answers.singleWhere((element) => (element['number'] == studentNumber))['location'];
      timesGoneToBackground = answers.singleWhere((element) => (element['number'] == studentNumber))['timesGoneToBackground'];
    }
    return OpenGrade(questionNumber, studentNumber, question, answer, currentAnswer, maxGrade, currentGrade, location!, timesGoneToBackground);
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
    double currentGrade = 0;
    GeoPoint? location;
    int timesGoneToBackground = 0;
    if (answers.where((element) => (element['number'] == studentNumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentNumber))['answer'];
      currentGrade = double.parse(answers.singleWhere((element) => (element['number'] == studentNumber))['currentGrade'].toString());
      location = answers.singleWhere((element) => (element['number'] == studentNumber))['location'];
      timesGoneToBackground = answers.singleWhere((element) => (element['number'] == studentNumber))['timesGoneToBackground'];
    }
    return MultipleChoiceGrade(questionNumber, studentNumber, question, input, answer, currentAnswer, maxGrade, currentGrade, location!, timesGoneToBackground);
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
    double currentGrade = 0;
    GeoPoint? location;
    int timesGoneToBackground = 0;
    if (answers.where((element) => (element['number'] == studentNumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentNumber))['answer'];
      currentGrade = double.parse(answers.singleWhere((element) => (element['number'] == studentNumber))['currentGrade'].toString());
      location = answers.singleWhere((element) => (element['number'] == studentNumber))['location'];
      timesGoneToBackground = answers.singleWhere((element) => (element['number'] == studentNumber))['timesGoneToBackground'];
    }
    return CodeCorrectionGrade(questionNumber, studentNumber, question, input, answer, currentAnswer, maxGrade, currentGrade, location!, timesGoneToBackground);
  }
}

