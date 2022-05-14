import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileintro/main.dart';
import 'package:mobileintro/storage.dart';

import 'Questions.dart';

class ManageQuestion extends StatefulWidget{
  const ManageQuestion({Key? key}) : super(key: key);

  @override
  _ManageQuestionState createState() => _ManageQuestionState();
}

class _ManageQuestionState extends State<ManageQuestion> {

  List<Question> questions = [];

  @override
  void initState() {
    Storage().getQuestions(0).then((questions) => {
      setState(() {
        this.questions = questions;
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
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