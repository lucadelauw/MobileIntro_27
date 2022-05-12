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
    return MyScaffoldQuestions(
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

class MyScaffoldQuestions extends StatelessWidget {
  final Widget body;

  const MyScaffoldQuestions({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: MyAppBar(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_left),
              label: 'Previous question'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_right),
              label: 'Next Question'
            )
          ],
        ),
        body: body);
  }
}