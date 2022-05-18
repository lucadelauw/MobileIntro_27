import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileintro/main.dart';
import 'package:mobileintro/Storage/storage.dart';

import '../Questions.dart';

class CreateQuestion extends StatefulWidget {
  const CreateQuestion({Key? key}) : super(key: key);

  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  int questionNumber = 1;
  var CodeCorrectionFieldText=TextEditingController();

  setQuestion() {
    switch (questionType) {
      case "Open":
        Storage().setOpenQuestion(
            questionNumber,
            OpenQuestion(questionNumber, questionController.text, 0,
                questionAnswerController.text, ""));
        break;
      case "CodeCorrection":
        Storage().setCodeCorrectionQuestion(
            questionNumber,
            CodeCorrectionQuestion(questionNumber, questionController.text, 0,
                "input", questionAnswerController.text, ""));
        break;
      case "MultipleChoice":
        Storage().setMultipleChoiceQuestion(
            questionNumber,
            MultipleChoiceQuestion(
                questionNumber,
                questionController.text,
                0,
                [
                  option1Controller.text,
                  option2Controller.text,
                  option3Controller.text
                ],
                int.parse(questionAnswerController.text),
                0));
        break;
    }
    questionNumber++;
    questionController.clear();
    questionGradeController.clear();
    questionAnswerController.clear();
    option1Controller.clear();
    option2Controller.clear();
    option3Controller.clear();
    questionType = null;
  }

  String? questionType;
  var questionController = TextEditingController();

  //var q_n = TextEditingController();
  var questionAnswerController = TextEditingController();
  var questionGradeController = TextEditingController();
  var option1Controller = TextEditingController();
  var option2Controller = TextEditingController();
  var option3Controller = TextEditingController();
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

                TextFormField(
                  decoration: InputDecoration(labelText:"Question" , border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "mustn't be empty";
                    }
                  },
                  controller: questionController,
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
                  value: questionType,
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
                      questionType = v;
                    });
                  },
                ),
                if (questionType == "CodeCorrection")
                  SizedBox(
                    height: 20,
                  ),

                if (questionType == "CodeCorrection")
                  TextFormField(
                    decoration: InputDecoration(labelText:"Add here the code that will be corrected " , border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "mustn't be empty";
                      }
                    },
                    controller: CodeCorrectionFieldText,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                if (questionType == "CodeCorrection")
                  SizedBox(
                    height: 17,
                  ),
                if (questionType == "MultipleChoice")
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
                          controller: option1Controller,
                          decoration: InputDecoration(labelText:"Chose 1" , border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(10))),
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
                          controller: option2Controller,
                          decoration: InputDecoration(labelText:"Chose 2" , border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText:"Chose 3" , border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(10))),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "mustn't be empty";
                            }
                          },
                          controller: option3Controller,

                        ),
                      ),
                    )
                  ]),
                SizedBox(
                  height: 55,
                ),

                TextFormField(
                  decoration: InputDecoration(labelText:"Question Grade" , border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "mustn't be empty";
                    }
                  },
                  controller: questionGradeController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 33,
                ),

                TextFormField(
                  decoration: InputDecoration(labelText:"Question Answer" , border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "mustn't be empty";
                    }
                  },
                  controller: questionAnswerController,
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
                              color: Colors.blue,
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
                              color: Colors.blue,
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
