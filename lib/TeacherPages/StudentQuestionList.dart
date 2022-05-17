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

  @override
  void initState() {
    Storage().getGradeQuestions(widget.studentnumber).then((value) {
      setState(() {
        questions = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(questions[index].question, style: TextStyle(fontSize: 22),),
                      trailing: Text(questions[index].maxGrade.toString()),
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