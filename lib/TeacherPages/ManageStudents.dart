import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobileintro/csvReader.dart';
import 'package:mobileintro/Storage/storage.dart';

import '../main.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {

  List<Student> students = [];
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
  var studentPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return MyScaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading) const CircularProgressIndicator(
              value: null,
              semanticsLabel: 'Linear progress indicator',
            ),
            if (!loading)
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: [
                for (Student student in students)
                  InputChip(
                    avatar: const Icon(Icons.remove),
                    label: Text(student.name),
                    onPressed: () async {
                      setLoading(true);
                      await Storage().removeStudent(student.number);
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
            const SizedBox(
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
                      const SizedBox(
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
                      const SizedBox(
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
                      const SizedBox(
                        width: 100,
                      ),
                      Flexible(child:
                      TextFormField(
                        controller: studentPasswordController,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (false) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Password'
                        ),
                      ),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          setLoading(true);
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Student Added')),
                          );
                          await Storage().addStudent(StudentWithPassword(int.parse(studentNumberController.value.text), studentNameController.value.text, studentPasswordController.value.text));
                          Storage().getStudents().then((students) => {
                            setState(() {
                              this.students = students;
                              studentNameController.text = "";
                              studentNumberController.text = "";
                              studentPasswordController.text = "";
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
                      onPressed: () async {
                        setLoading(true);
                        CsvReader().getStudents().then((students) async {
                          await Storage().addStudents(students);
                          Storage().getStudents().then((students) => {
                            setState(() {
                              this.students = students;
                            }),
                            setLoading(false)
                          });
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