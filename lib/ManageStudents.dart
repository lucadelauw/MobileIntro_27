import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobileintro/storage.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();

}

class _StudentPageState extends State<StudentPage> {

  List<StudentObject> students = [];

  @override
  void initState() {
    Storage.getStudents().then((List<StudentObject> students) => {
      for (var student in students) {
        log(student.studentNumber.toString() + " " + student.name)
      },
      setState(() {
        this.students = students;
      })
    });
    super.initState();
  }

  var studentNumberController = TextEditingController();
  var studentNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: const Text("E-xam"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: [
                for (var student in students)
                  InputChip(
                    avatar: Icon(Icons.remove),
                    label: Text(student.name),
                    onPressed: () {
                      setState(() {
                        log("here");
                        students.remove(student);
                        Storage.setStudents(students);
                      });
                    } ,
                  )
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                      ),
                      Flexible(child:
                      TextFormField(
                        controller: studentNumberController,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (!RegExp(r'^[0-9]{6}$').hasMatch(value!)) {
                            return 'Please enter a valid studentnumber';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Studentnumber'
                        ),
                      ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Flexible(child:
                      TextFormField(
                        controller: studentNameController,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (false) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Name'
                        ),
                      ),
                      ),
                      SizedBox(
                        width: 100,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Student Added')),
                          );
                          log(studentNumberController.value.text);
                          log(studentNameController.value.text);
                          students.add(StudentObject(int.parse(studentNumberController.value.text), studentNameController.value.text));
                          Storage.setStudents(students).then((value) => {
                            Storage.getStudents().then((students) => {
                              setState(() {
                                this.students = students;
                              })
                            })
                          });
                        }
                      },
                      child: const Text('Add student'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}