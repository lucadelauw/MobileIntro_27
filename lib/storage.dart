import 'dart:developer';
import 'package:mobileintro/firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Storage {

  static bool inited = false;

  static Future<void> addStudent(int number, String name) async {
    if (!inited) {
      await init();
    }

    await FirebaseFirestore.instance.collection('students').where(
        'number', isEqualTo: number).get().then((value) async =>
    {
      if (value.size == 0) {
        await FirebaseFirestore.instance.collection('students').add(
            {'name': name, 'number': number})
      }
    });
  }

  static Future<void> removeStudent(int number) async {
    if (!inited) {
      await init();
    }

    await FirebaseFirestore.instance.collection('students').where(
        'number', isEqualTo: number).get().then((value) =>
        value.docs.first.reference.delete());
  }

  static Future<Map<int, String>> getStudents() async {
    if (!inited) {
      await init();
    }

    var students = <int, String>{};

    /*await FirebaseFirestore.instance.collection('E-xam').doc('students').get().then((value) => {
      students = value.data()!.map((key, value) => MapEntry(int.parse(key), value.toString()))
    });*/

    await FirebaseFirestore.instance.collection('students').get().then((
        value) =>
    {
      value.docs.forEach((element) {
        students[element.get('number')] = element.get('name');
      })
    });

    return students;
  }

  static Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseFirestore.instance.enablePersistence();
    inited = true;
    return;
  }

  static Future<void> setMultipleChoiceQuestion(int questionNumber, MultipleChoiceQuestion questionData) async {
    if (!inited) {
      await init();
    }

    await FirebaseFirestore.instance.collection('questions').doc(
        questionNumber.toString()).set({'question': questionData.question, 'type': 'MultipleChoice', 'input': questionData.input, 'answer': questionData.answer});
  }

  static Future<void> setOpenQuestion(int questionNumber, OpenQuestion questionData) async {
    if (!inited) {
      await init();
    }

    await FirebaseFirestore.instance.collection('questions').doc(
        questionNumber.toString()).set({'question': questionData.question, 'type': 'Open', 'input': questionData.input, 'answer': questionData.answer});
  }

  static Future<void> setCodeCorrectionQuestion(int questionNumber, CodeCorrectionQuestion questionData) async {
    if (!inited) {
      await init();
    }

    await FirebaseFirestore.instance.collection('questions').doc(
        questionNumber.toString()).set({'question': questionData.question, 'type': 'CodeCorrection', 'input': questionData.input, 'answer': questionData.answer});
  }

  static Future<List<Question>> getQuestions() async {
    if (!inited) {
      await init();
    }

    List<Question> questions = [];
    await FirebaseFirestore.instance.collection('questions').get().then((value) => {
      value.docs.forEach((element) {
        questions.add(Question(element.get('question')));
      })
    });
    log(questions.toString());
    return questions;
  }
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