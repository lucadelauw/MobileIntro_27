import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileintro/main.dart';
import 'package:mobileintro/storage.dart';

import 'Questions.dart';

class CreateQuestion extends StatefulWidget {
  const CreateQuestion({Key? key}) : super(key: key);

  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  int questionnumber = 1;

  setQuestion() {
    switch (val) {
      case "Open":
        Storage().setOpenQuestion(questionnumber, OpenQuestion(q.text, q_a.text, "", questionnumber, 0));
        break;
      case "CodeCorrection":
        Storage().setCodeCorrectionQuestion(questionnumber, CodeCorrectionQuestion(q.text, "", q_a.text, "", questionnumber, 0));
        break;
      case "MultipleChoice":
        Storage().setMultipleChoiceQuestion(questionnumber, MultipleChoiceQuestion(q.text, [ch_1.text, ch_2.text, ch_3.text], int.parse(q_a.text), 0, questionnumber, 0));
        break;
    }
    questionnumber++;
    q.clear();
    q_g.clear();
    q_a.clear();
    ch_1.clear();
    ch_2.clear();
    ch_3.clear();
    val=null;
  }


  String? val;
  var q = TextEditingController();
  //var q_n = TextEditingController();
  var q_a = TextEditingController();
  var q_g = TextEditingController();
  var ch_1 = TextEditingController();
  var ch_2 = TextEditingController();
  var ch_3 = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 18,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "mustn't be empty";
                    }
                  },
                  controller: q,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 30,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(12),
                  hint: Text("Question Type"),
                  value: val,
                  items: [
                    DropdownMenuItem(
                      child: Text("open"),
                      value: "Open",
                    ),
                    DropdownMenuItem(
                      child: Text("Code correction"),
                      value: "CodeCorrection",
                    ),
                    DropdownMenuItem(
                      child: Text("Multiplechoice"),
                      value: "MultipleChoice",
                    ),
                  ],
                  onChanged: (v) {
                    setState(() {
                      val = v;
                    });
                  },
                ),
                SizedBox(
                  height: 17,
                ),
                if (val == "MultipleChoice")
                  Row(children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "mustn't be empty";
                            }
                          },
                          controller: ch_1,
                          decoration: InputDecoration(hintText: "Chose 1"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "mustn't be empty";
                            }
                          },
                          controller: ch_2,
                          decoration: InputDecoration(hintText: "Chose 2"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "mustn't be empty";
                            }
                          },
                          controller: ch_3,
                          decoration: InputDecoration(hintText: "Chose 3"),
                        ),
                      ),
                    )
                  ]),
                SizedBox(
                  height: 55,
                ),
                Text(
                  "Question Grade:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 18,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "mustn't be empty";
                    }
                  },
                  controller: q_g,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 33,
                ),
                Text(
                  "Question Answer:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 18,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "mustn't be empty";
                    }
                  },
                  controller: q_a,
                  keyboardType: TextInputType.multiline,
                  minLines: null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyHomePage(title: "E-xam"),
                                ),
                                    (route) => false);
                          }
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              "Finish",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          height: 50,
                          margin: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            setQuestion();
                          }
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              "NEXT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          margin: EdgeInsets.all(18),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}