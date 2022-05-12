import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:mobileintro/firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Storage {

  // Singleton
  static final Storage _storage = Storage._privateConstructor();
  static bool _isSynced = false;

  var students = <int, String>{};

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

    //var students = <int, String>{};

    /*await FirebaseFirestore.instance.collection('students').get().then((value) => {
      value.docs.forEach((element) {
        students[element.get('number')] = element.get('name');
      })
    });*/

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
        questionNumber.toString()).set({'question': questionData.question, 'type': 'MultipleChoice', 'input': questionData.input, 'answer': questionData.answer});
  }

  Future<void> setOpenQuestion(int questionNumber, OpenQuestion questionData) async {
    await _init();

    await FirebaseFirestore.instance.collection('questions').doc(
        questionNumber.toString()).set({'question': questionData.question, 'type': 'Open', 'input': questionData.input, 'answer': questionData.answer});
  }

  Future<void> setCodeCorrectionQuestion(int questionNumber, CodeCorrectionQuestion questionData) async {
    await _init();

    await FirebaseFirestore.instance.collection('questions').doc(
        questionNumber.toString()).set({'question': questionData.question, 'type': 'CodeCorrection', 'input': questionData.input, 'answer': questionData.answer});
  }

  Future<List<Question>> getQuestions() async {
    await _init();

    List<Question> questions = [];
    await FirebaseFirestore.instance.collection('questions').get().then((value) => {
      value.docs.forEach((element) {
        questions.add(Question(element.get('question')));
      })
    });
    return questions;
  }

  Future<bool> isSynced() async {
     await _init();
     return _isSynced;
  }

  // TODO: getQuestion(int questionNumber)
}

class Question {
  String question = '';
  Question(this.question);
}

class MultipleChoiceQuestion implements Question {
  @override
  String question;
  List<String> input = [];
  String answer = "";

  MultipleChoiceQuestion(this.question, this.input, this.answer) {
    if (!input.contains(answer)) {
      throw("MultipleChoiceQuestion has no correct answer");
    }
  }
}

class OpenQuestion implements Question {
  @override
  String question;
  String input = "";
  String? answer = "";

  OpenQuestion(this.question, this.input, this.answer);
}

class CodeCorrectionQuestion implements Question{
  @override
  String question;
  String input = "";
  String answer = "";

  CodeCorrectionQuestion(this.question, this.input, this.answer);
}