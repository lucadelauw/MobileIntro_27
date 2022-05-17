import 'package:flutter/material.dart';
import 'package:mobileintro/StudentQuestionList.dart';
import 'package:mobileintro/storage.dart';

class StudentGradesList extends StatefulWidget {
  const StudentGradesList({Key? key}) : super(key: key);

  @override
  _StudentGradesListState createState() => _StudentGradesListState();
}

class _StudentGradesListState extends State<StudentGradesList> {
  List<Student> students = [];

  @override
  void initState() {
    Storage().getStudents().then((students) {
      setState(() {
        this.students = students;
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
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(students[index].name, style: TextStyle(fontSize: 22),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => StudentQuestionList(studentnumber: students[index].number),));
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