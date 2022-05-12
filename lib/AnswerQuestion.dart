import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileintro/main.dart';
import 'package:mobileintro/storage.dart';

class AnswerQuestion extends StatefulWidget{
  const AnswerQuestion({Key? key}) : super(key: key);

  @override
  _AnswerQuestionState createState() => _AnswerQuestionState();
}

class _AnswerQuestionState extends State<AnswerQuestion> {

  List<Question> questions = [];
  int currentQuestion = 0;

  @override
  void initState() {
    Storage().getQuestions().then((questions) => {
      setState(() {
        this.questions = questions;
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
      bottomNavigationBar: MyBottomBar(
          previousCallback: () => {
            if (currentQuestion > 0) {
              setState(() => {
                currentQuestion--
              })
            }
          },
          nextCallback: () => {
            if (currentQuestion + 1 < questions.length) {
              setState(() => {
                currentQuestion++
              })
            }
          }),
      body:
          questions.isNotEmpty ? questions[currentQuestion].getWidget() : null
    );
  }

}

class _MyBottomBarState extends State<MyBottomBar> {
  Timer? timer;
  int totalQuestion = 0;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      Storage().getQuestionCount().then((value) => {
        if (mounted) {
          setState(() {
            totalQuestion = value;
          })
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: const Icon(Icons.arrow_left), onPressed: widget.previousCallback,),
          Text("Question  of " + totalQuestion.toString()),
          IconButton(icon: const Icon(Icons.arrow_right), onPressed: widget.nextCallback,),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class MyBottomBar extends StatefulWidget {
  final previousCallback;
  final nextCallback;


  const MyBottomBar({Key? key, required this.previousCallback, required this.nextCallback}) : super(key: key);

  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}