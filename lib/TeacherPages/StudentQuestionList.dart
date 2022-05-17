import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobileintro/TeacherPages/GradeQuestions.dart';
import 'package:mobileintro/Questions.dart';
import 'package:mobileintro/Storage/storage.dart';

class StudentQuestionList extends StatefulWidget {
  final int studentnumber;
  const StudentQuestionList({Key? key, required this.studentnumber}) : super(key: key);

  @override
  _StudentQuestionListState createState() => _StudentQuestionListState();
}

class _StudentQuestionListState extends State<StudentQuestionList> {

  List<QuestionGrade> questions = [];
  double currentGrade20 = 0;

  @override
  void initState() {
    Storage().getGradeQuestions(widget.studentnumber).then((value) {
      double totalMaxScore = 0;
      double totalCurrentScore = 0;
      for (QuestionGrade question in value) {
        totalMaxScore += question.maxGrade;
        totalCurrentScore += question.currentGrade;
      }
      setState(() {
        questions = value;
        currentGrade20 = totalCurrentScore / (totalMaxScore / 20);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child : Text(currentGrade20.toStringAsFixed(2) + " / 20", style: const TextStyle(fontSize: 20),)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(questions[index].question, style: TextStyle(fontSize: 22),),
                      trailing: Text(questions[index].currentGrade.toString() + " / " + questions[index].maxGrade.toString()),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) =>
                            Scaffold(
                              appBar: AppBar(),
                              body: Padding(
                                padding: const EdgeInsets.all(30),
                                child: questions[index].getWidget()
                            ),
                        )));
                      }
                  );
                }
            ),
          )
        ]),
      ),
    );
  }
}