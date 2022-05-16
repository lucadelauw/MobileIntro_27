import 'package:flutter/material.dart';

class StudentQuestionList extends StatefulWidget {
  const StudentQuestionList({Key? key}) : super(key: key);

  @override
  _StudentQuestionListState createState() => _StudentQuestionListState();
}

class _StudentQuestionListState extends State<StudentQuestionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Text("Omer",style: TextStyle(fontSize: 22),),
        SizedBox(height: 25,),
        ListTile(title:Text("Flutter 1",style: TextStyle(fontSize: 22),) ,trailing: Text("18/20",style: TextStyle(fontSize: 25),),),
        ListTile(title:Text(" math 1",style: TextStyle(fontSize: 22),) ,trailing: Text("16/20",style: TextStyle(fontSize: 25),),),
        ListTile(title:Text("exam 1",style: TextStyle(fontSize: 22),) ,trailing: Text("20/20",style: TextStyle(fontSize: 25),),),
      ]),
    );
  }
}