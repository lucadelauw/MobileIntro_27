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
      bottomNavigationBar: const MyBottomBar(),
      body: ListView(
        children: [
          for (var question in questions)
            Container(
              height: 50,
              child: Center(child: Text(question.question)),
            ),
        ],
      ),
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
          IconButton(icon: const Icon(Icons.arrow_left), onPressed: () {},),
          Text("Question 1 of 12"),
          IconButton(icon: const Icon(Icons.arrow_right), onPressed: () {},),
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
  const MyBottomBar({Key? key}) : super(key: key);

  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}