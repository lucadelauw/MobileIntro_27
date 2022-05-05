import 'dart:developer';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:mobileintro/firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Storage {

  // Singleton
  static final Storage _storage = Storage._privateConstructor();

  factory Storage() {
    return _storage;
  }

  Storage._privateConstructor();

  static bool inited = false;

   Future<void> addStudent(int number, String name) async {
     await _init();

    await FirebaseFirestore.instance.collection('students').where(
        'number', isEqualTo: number).get().then((value) async =>
    {
      if (value.size == 0) {
        await FirebaseFirestore.instance.collection('students').add(
            {'name': name, 'number': number})
      }
    });
  }

  Future<void> addStudents(Map<int, String> students) async {
    await _init();

    List<Future> futures = [];
    students.forEach((number, name) {
      futures.add(
        FirebaseFirestore.instance.collection('students').add(
          {'name': name, 'number': number}
        )
      );
    });

    await Future.wait(futures);
  }

  Future<void> removeStudent(int number) async {
    await _init();

    await FirebaseFirestore.instance.collection('students').where(
        'number', isEqualTo: number).get().then((value) =>
        value.docs.first.reference.delete());
  }

  Future<Map<int, String>> getStudents() async {
    await _init();

    var students = <int, String>{};

    await FirebaseFirestore.instance.collection('students').get().then((
        value) =>
    {
      value.docs.forEach((element) {
        students[element.get('number')] = element.get('name');
      })
    });

    return students;
  }

  Future<void> _init() async {
     try {
       if (Firebase.apps.isNotEmpty) {
         return;
       }
     } catch(e) {
       log("Initializing firebase/firestore");
       await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
       await FirebaseFirestore.instance.enablePersistence();
       inited = true;
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

  Stream<bool> isSynced() async* {
     await _init();

     while (true) {
       await for (final snapshot in FirebaseFirestore.instance.collection("students").snapshots(includeMetadataChanges: true)) {
         yield (!snapshot.metadata.isFromCache/* && !snapshot.metadata.hasPendingWrites*/);
       }
     }
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