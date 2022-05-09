import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobileintro/csvReader.dart';
import 'package:mobileintro/storage.dart';

import 'main.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {

  var students = <int, String>{};
  bool loading = true;

  @override
  void initState() {
    Storage().getStudents().then((students) => {
      setState(() {
        this.students = students;
      }),
      setLoading(false)
    });
    super.initState();
  }

  var studentNumberController = TextEditingController();
  var studentNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return MyScaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading) CircularProgressIndicator(
              value: null,
              semanticsLabel: 'Linear progress indicator',
            ),
            if (!loading)
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: [
                for (int key in students.keys)
                  InputChip(
                    avatar: const Icon(Icons.remove),
                    label: Text(students[key]!),
                    onPressed: () {
                      setLoading(true);
                      Storage().removeStudent(key);
                      Storage().getStudents().then((students) => {
                        setState(() {
                          this.students = students;
                        }),
                        setLoading(false)
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          setLoading(true);
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Student Added')),
                          );
                          //students[int.parse(studentNumberController.value.text)] = studentNameController.value.text;
                          Storage().addStudent(int.parse(studentNumberController.value.text), studentNameController.value.text);
                          Storage().getStudents().then((students) => {
                            setState(() {
                              this.students = students;
                            }),
                            setLoading(false)
                          });
                        }
                      },
                      child: const Text('Add student'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setLoading(true);
                        CsvReader().getStudents().then((students) => {
                          Storage().addStudents(students),
                          Storage().getStudents().then((students) => {
                            setState(() {
                              this.students = students;
                            }),
                            setLoading(false)
                          })
                        });
                      },
                      child: const Text('Import students'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  setLoading(bool loading) {
    if (mounted) {
      setState(() {
        this.loading = loading;
      });
    }
  }
}