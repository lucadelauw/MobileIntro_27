import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileintro/firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'Questions.dart';

class Storage {

  // Singleton
  static final Storage _storage = Storage._privateConstructor();
  static bool _isSynced = false;

  final Geolocator geolocator = Geolocator();
  var students = <int, String>{};
  var questionsStorage = <QuestionStorage>[];

  factory Storage() {
    return _storage;
  }

  Storage._privateConstructor();

   Future<void> addStudent(int number, String name) async {
     await _init();

     students[number] = name;
     FirebaseFirestore.instance.collection('students').doc(number.toString()).set({'name': name, 'number': number});
  }

  Future<void> addStudents(Map<int, String> students) async {
    await _init();

    students.addAll(students);
    var batch = FirebaseFirestore.instance.batch();

    students.forEach((number, name) {
      batch.set(FirebaseFirestore.instance.collection('students').doc(number.toString()), {'name': name, 'number': number});
    });

    batch.commit();
  }

  Future<void> removeStudent(int number) async {
    await _init();

    students.remove(number);
    FirebaseFirestore.instance.collection('students').doc(number.toString()).delete();
  }

  Future<Map<int, String>> getStudents() async {
    await _init();

    return students;
  }

  Future<void> _init() async {
     try {
       if (Firebase.apps.isNotEmpty) {
         return;
       } else {
         throw("");
       }
     } catch(e) {
       log("Initializing firebase/firestore");
       await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
       FirebaseFirestore.instance.collection('students').snapshots().listen((event) async {
         var tempStudents = <int, String>{};
         await FirebaseFirestore.instance.collection('students').get().then((value) => {
           value.docs.forEach((element) {
             tempStudents[element.get('number')] = element.get('name');
           }),
           students = tempStudents
         });
       });
       FirebaseFirestore.instance.collection('questions').snapshots().listen((event) async {
         var tempQuestions = <QuestionStorage>[];
         var element;
         await FirebaseFirestore.instance.collection('questions').get().then((value) {
           for (int i = 0 ; i < value.docs.length; i++) {
             element = value.docs[i];
             List<Map<String, dynamic>> answers = [];
             for (dynamic answer in element.get('answers')) {
             answers.add(Map<String, dynamic>.from(answer));
             }
             if(element.get('type') == "Open") {
             tempQuestions.add(OpenQuestionStorage(element.get('question'), element.get('answer'), answers, i));
             }
             if(element.get('type') == "MultipleChoice") {
             tempQuestions.add(MultipleChoiceQuestionStorage(element.get('question'), List<String>.from(element.get('input')), element.get('answer'), answers, i));
             }
             if(element.get('type') == "CodeCorrection") {
             tempQuestions.add(CodeCorrectionQuestionStorage(element.get('question'), element.get('input'), element.get('answer'), answers, i));
             }
           }
           questionsStorage = tempQuestions;
         });
       });
       Timer.periodic(const Duration(seconds: 1), (timer) async {
         await FirebaseFirestore.instance.collection("students").snapshots(includeMetadataChanges: true).first.then((value) => {
           _isSynced = (!value.metadata.isFromCache && !value.metadata.hasPendingWrites),
         });
       });
     }
  }

  Future<void> setMultipleChoiceQuestion(int questionNumber, MultipleChoiceQuestion questionData) async {
    await _init();

    await FirebaseFirestore.instance.collection('questions').doc(
        questionNumber.toString()).set({'question': questionData.question, 'type': 'MultipleChoice', 'input': questionData.input, 'answer': questionData.answer, 'answers': []});
  }

  Future<void> setOpenQuestion(int questionNumber, OpenQuestion questionData) async {
    await _init();

    questionsStorage[questionNumber - 1] = OpenQuestionStorage(questionData.question, questionData.answer!, [], questionNumber);
    await FirebaseFirestore.instance.collection('questions').doc(
        questionNumber.toString()).set({'question': questionData.question, 'type': 'Open', 'answer': questionData.answer, 'answers': []});
  }

  Future<void> setCodeCorrectionQuestion(int questionNumber, CodeCorrectionQuestion questionData) async {
    await _init();

    await FirebaseFirestore.instance.collection('questions').doc(
        questionNumber.toString()).set({'question': questionData.question, 'type': 'CodeCorrection', 'input': questionData.input, 'answer': questionData.answer, 'answers': []});
  }

  setAnswer(int studentnumber, int questionnumber, dynamic answer, int timeGoneToBackground) async {
     var loc = await _getLocation();
     var tempanswer = questionsStorage[questionnumber].answers;
     if (tempanswer.where((element) => element['number'] == studentnumber).isNotEmpty) {
       tempanswer.singleWhere((element) => element['number'] == studentnumber).update('answer', (value) => answer);
       tempanswer.singleWhere((element) => element['number'] == studentnumber).update('location', (value) => GeoPoint(loc!.latitude, loc.longitude));
       tempanswer.singleWhere((element) => element['number'] == studentnumber).update('timesGoneToBackground', (value) {return value + timeGoneToBackground;});
     } else {
       tempanswer.add({'number': studentnumber, 'answer': answer, 'location': GeoPoint(loc!.latitude, loc.longitude), 'timesGoneToBackground': timeGoneToBackground});
     }
     FirebaseFirestore.instance.collection('questions').doc((questionnumber + 1).toString()).update({
       'answers': tempanswer,
     });
  }

  Future<List<Question>> getQuestions(int studentnumber) async {
    await _init();

    List<Question> questions = [];
    for (var value in questionsStorage) {
      questions.add(value.toQuestion(studentnumber));
    }
    return questions;
  }

  Future<List<Question>> getQuestionsTeacher() async {
    await _init();

    List<Question> questions = [];
    for (var value in questionsStorage) {
      questions.add(value.toQuestionTeacher());
    }
    return questions;
  }

  Future<bool> isSynced() async {
     await _init();
     return _isSynced;
  }

  // TODO: getQuestion(int questionNumber)
  Future<Position?> _getLocation() async {
     return await Geolocator.getCurrentPosition();
  }
}

abstract class QuestionStorage {
  String question = '';
  List<Map<String, dynamic>> answers= [];
  QuestionStorage(this.question, this.answers);
  int questionnumber = 0;

  toQuestion(int studentnumber);
  toQuestionTeacher();
}

class OpenQuestionStorage implements QuestionStorage {
  @override
  String question;
  @override
  List<Map<String, dynamic>> answers;
  @override
  int questionnumber;
  String answer;

  OpenQuestionStorage(this.question, this.answer, this.answers, this.questionnumber);

  @override
  toQuestion(int studentnumber) {
    String? currentAnswer;
    if (answers.where((element) => (element['number'] == studentnumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentnumber))['answer'];
    }
    return OpenQuestion(question, answer, currentAnswer, questionnumber, studentnumber);
  }
  @override
  toQuestionTeacher() {
    return OpenQuestion(question, answer, "", questionnumber, 0);
  }
}
class MultipleChoiceQuestionStorage implements QuestionStorage {
  @override
  String question;
  @override
  List<Map<String, dynamic>> answers;
  @override
  int questionnumber;
  int answer;
  List<String> input;

  MultipleChoiceQuestionStorage(this.question, this.input, this.answer, this.answers, this.questionnumber);

  @override
  toQuestion(int studentnumber) {
    int? currentAnswer;
    if (answers.where((element) => (element['number'] == studentnumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentnumber))['answer'];
    }
    return MultipleChoiceQuestion(question, input, answer, currentAnswer, questionnumber, studentnumber);
  }
  @override
  toQuestionTeacher() {
    return MultipleChoiceQuestion(question, input, answer, 0, questionnumber, 0);
  }
}
class CodeCorrectionQuestionStorage implements QuestionStorage {
  @override
  String question;
  @override
  List<Map<String, dynamic>> answers;
  @override
  int questionnumber;
  String input;
  String answer;

  CodeCorrectionQuestionStorage(this.question, this.input, this.answer, this.answers, this.questionnumber);

  @override
  toQuestion(int studentnumber) {
    String? currentAnswer;
    if (answers.where((element) => (element['number'] == studentnumber)).isNotEmpty) {
      currentAnswer = answers.singleWhere((element) => (element['number'] == studentnumber))['answer'];
    }
    return CodeCorrectionQuestion(question, input, answer, currentAnswer, questionnumber, studentnumber);
  }
  @override
  toQuestionTeacher() {
    return CodeCorrectionQuestion(question, input, answer, "", questionnumber, 0);
  }
}