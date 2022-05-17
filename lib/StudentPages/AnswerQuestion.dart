import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileintro/main.dart';
import 'package:mobileintro/Storage/storage.dart';

import '../Questions.dart';

class AnswerQuestion extends StatefulWidget{
  final int studentnumber;

  const AnswerQuestion({Key? key, required this.studentnumber}) : super(key: key);

  @override
  _AnswerQuestionState createState() => _AnswerQuestionState();
}

class _AnswerQuestionState extends State<AnswerQuestion> {

  List<Question> questions = [];
  List<Widget> questionWidgets = [];
  int currentQuestion = 0;

  @override
  void initState() {
    Storage().getQuestions(widget.studentnumber).then((questions) => {
      setState(() {
        this.questions = questions;
        questions.forEach((element) {
          questionWidgets.add(element.getWidget(ObjectKey(element)));
        });
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: MyAppBar(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: const Icon(Icons.arrow_left), onPressed: () => {
              if (currentQuestion > 0) {
                setState(() => {
                  currentQuestion--
                })
              }
            },),
            Text("Question ${currentQuestion + 1} of " + questions.length.toString()),
            IconButton(icon: const Icon(Icons.arrow_right), onPressed: () => {
              if (currentQuestion + 1 < questions.length) {
                setState(() => {
                  currentQuestion++
                })
              }
            },),
          ],
        ),
      ),
      body:
          questionWidgets.isNotEmpty ? questionWidgets[currentQuestion] : null
    );
  }
}