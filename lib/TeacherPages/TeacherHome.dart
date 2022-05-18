import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mobileintro/TeacherPages/CreateQuestion.dart';
import 'package:mobileintro/TeacherPages/ManageQuestion.dart';
import 'package:mobileintro/TeacherPages/ManageStudents.dart';
import 'package:mobileintro/TeacherPages/StudentGradesList.dart';
import 'package:mobileintro/TeacherPages/StudentQuestionList.dart';
import 'package:mobileintro/main.dart';
import 'package:mobileintro/Storage/storage.dart';

class TeacherHome extends StatelessWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _navigateStudentPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudentPage()),
      );
    }

    void _navigateQuestionPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateQuestion()),
      );
    }

    void _navigateGradesPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudentGradesList()),
      );
    }

    return MyScaffold(
        body: Stack(
      children: [
        Container(height: double.infinity,width: double.infinity, decoration:  BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage("images/background.PNG") )),),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 900,
                height: 100,
                child: TextButton(
                  onPressed: _navigateStudentPage,
                  child: const Text(
                    'Students',
                    style: TextStyle(fontSize: 26),
                  ),
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                ),
              ),
              SizedBox(
                height: 100 / 2,
              ),
              SizedBox(
                width: 900,
                height: 100,
                child: TextButton(
                  onPressed: _navigateQuestionPage,
                  child: const Text(
                    'Questions',
                    style: TextStyle(fontSize: 26),
                  ),
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                ),
              ),
              SizedBox(
                height: 100 / 2,
              ),
              SizedBox(
                width: 900,
                height: 100,
                child: TextButton(
                  onPressed: _navigateGradesPage,
                  child: const Text(
                    'Grades',
                    style: TextStyle(fontSize: 26),
                  ),
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
