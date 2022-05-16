import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobileintro/AnswerQuestion.dart';
import 'package:mobileintro/storage.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  bool showpass = true;
  var id= TextEditingController();
  var passwordController= TextEditingController();
  var formkey=GlobalKey<FormState>();
  String? dropdownValue;
  Map<int, String> students = <int, String>{};

  @override
  void initState() {
    Storage().getStudents().then((students) => {
      if (mounted) {
        setState(() {
          this.students = students;
        })
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formkey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: students.entries.map((e) => DropdownMenuItem(
                        value: e.key.toString(),
                        child: Text(e.key.toString() + ": " + e.value),
                      )).toList(),
                      validator: (value) {
                        if (value == null || value == "") {
                          return 'Please enter a valid studentnumber';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Password:",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: showpass,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showpass = !showpass;
                                });
                              },
                              icon: Icon(!showpass
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          _login(int.parse(dropdownValue!), passwordController.text);
                        }
                      },
                      child: Container(
                        child:  Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        height: 50,
                        decoration:
                        BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  _login(int studentnumber, password){
    Storage().checkStudentPassword(studentnumber, password).then((value) => {
      if (value == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Wrong password")))
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AnswerQuestion(studentnumber: studentnumber),))
      }
    });
  }
}