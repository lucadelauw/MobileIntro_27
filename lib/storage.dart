import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileintro/firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Storage {

  // Singleton
  static final Storage _storage = Storage._privateConstructor();
  static bool _isSynced = false;

  var students = <int, String>{};
  var questions = <Question>[];

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
         var tempQuestions = <Question>[];
         await FirebaseFirestore.instance.collection('questions').get().then((value) => {
           value.docs.forEach((element) {
             if(element.get('type') == "Open") {
               tempQuestions.add(OpenQuestion(element.get('question'), element.get('answer')));
             }
             if(element.get('type') == "MultipleChoice") {
               tempQuestions.add(MultipleChoiceQuestion(element.get('question'), element.get('input'), element.get('answer')));
             }
             if(element.get('type') == "CodeCorrection") {
               tempQuestions.add(CodeCorrectionQuestion(element.get('question'), element.get('input'), element.get('answer')));
             }
           }),
           questions = tempQuestions
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
        questionNumber.toString()).set({'question': questionData.question, 'type': 'Open', 'answer': questionData.answer});
  }

  Future<void> setCodeCorrectionQuestion(int questionNumber, CodeCorrectionQuestion questionData) async {
    await _init();

    await FirebaseFirestore.instance.collection('questions').doc(
        questionNumber.toString()).set({'question': questionData.question, 'type': 'CodeCorrection', 'input': questionData.input, 'answer': questionData.answer});
  }

  Future<List<Question>> getQuestions() async {
    await _init();

    /*List<Question> questions = [];
    await FirebaseFirestore.instance.collection('questions').get().then((value) => {
      value.docs.forEach((element) {
        if(element.get('type') == "Open") {
          questions.add(OpenQuestion(element.get('question'), element.get('answer')));
        }
        if(element.get('type') == "MultipleChoice") {
          questions.add(MultipleChoiceQuestion(element.get('question'), element.get('input'), element.get('answer')));
        }
        if(element.get('type') == "CodeCorrection") {
          questions.add(CodeCorrectionQuestion(element.get('question'), element.get('input'), element.get('answer')));
        }
      })
    });*/
    return questions;
  }

  Future<int> getQuestionCount() async {
     await _init();
     return questions.length;
  }

  Future<bool> isSynced() async {
     await _init();
     return _isSynced;
  }

  Future<Question?> getQuestion(int questionNumber) async {
     await _init();

     Question? toReturn;
     await FirebaseFirestore.instance.collection('questions').doc(questionNumber.toString()).get().then((value) => {
       if(value.get('type') == "Open") {
         toReturn = OpenQuestion(value.get('question'), value.get('answer'))
       },
       if(value.get('type') == "MultipleChoice") {
         toReturn = MultipleChoiceQuestion(value.get('question'), value.get('input'), value.get('answer'))
       },
       if(value.get('type') == "CodeCorrection") {
         toReturn = CodeCorrectionQuestion(value.get('question'), value.get('input'), value.get('answer'))
       }
     });

     return toReturn;
  }

  // TODO: getQuestion(int questionNumber)
}

abstract class Question {
  String question = '';
  Question(this.question);
  StatefulWidget getWidget();
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

  @override
  StatefulWidget getWidget() {
    // TODO: implement getWidget
    throw UnimplementedError();
  }
}

class OpenQuestion implements Question {
  @override
  String question;
  String? answer = "";

  OpenQuestion(this.question, this.answer);

  @override
  StatefulWidget getWidget() {
    return OpenQuestionWidget(question: OpenQuestion(question, answer));
  }
}

class OpenQuestionWidget extends StatefulWidget {
  final OpenQuestion question;

  const OpenQuestionWidget({Key? key, required this.question}) : super(key: key);

  @override
  _OpenQuestionWidgetState createState() => _OpenQuestionWidgetState();
}

class _OpenQuestionWidgetState extends State<OpenQuestionWidget> {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.question.question),
        Form(child:
          TextFormField(
            controller: controller,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (false) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: const InputDecoration(
                labelText: 'Answer'
            ),
          ),
        )
      ],
    );
  }

}

class CodeCorrectionQuestion implements Question{
  @override
  String question;
  String input = "";
  String answer = "";

  CodeCorrectionQuestion(this.question, this.input, this.answer);

  @override
  StatefulWidget getWidget() {
    // TODO: implement getWidget
    throw UnimplementedError();
  }
}