import 'package:flutter/material.dart';
import 'package:mobileintro/Questions.dart';
import 'package:mobileintro/Storage/storage.dart';

import '../main.dart';

class CreateQuestion extends StatefulWidget {
  const CreateQuestion({Key? key}) : super(key: key);

  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  int questionNumber = 1;
  var CodeCorrectionFieldText = TextEditingController();

  setQuestion() {
    switch (questionType) {
      case "Open":
        Storage().setOpenQuestion(
            questionNumber,
            OpenQuestion(questionNumber, questionController.text, 0,
                questionAnswerController.text, ""), double.parse(questionGradeController.text));
        break;
      case "CodeCorrection":
        Storage().setCodeCorrectionQuestion(
            questionNumber,
            CodeCorrectionQuestion(questionNumber, questionController.text, 0,
                "input", questionAnswerController.text, ""), double.parse(questionGradeController.text));
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
                0), double.parse(questionGradeController.text));
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
  var option4Controller = TextEditingController();
  var option5Controller = TextEditingController();
  var formkey = GlobalKey<FormState>();
  int numberofchose = 1;

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
                  decoration: InputDecoration(
                      labelText: "Question",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10))),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: DropdownButton<String>(
                    focusColor: Colors.transparent,
                    underline: Container(),
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
                ),
                if (questionType == "CodeCorrection")
                  SizedBox(
                    height: 20,
                  ),
                if (questionType == "CodeCorrection")
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Add here the code that will be corrected ",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10))),
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
                  SizedBox(
                    height: 15,
                  ),
                if (questionType == "MultipleChoice" && numberofchose != 0)
                  Row(children: [
                    if (numberofchose >= 1)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "mustn't be empty";
                              }
                            },
                            controller: option1Controller,
                            decoration: InputDecoration(
                                labelText: "Chose 1",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ),
                    if (numberofchose >= 2)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "mustn't be empty";
                              }
                            },
                            controller: option2Controller,
                            decoration: InputDecoration(
                                labelText: "Chose 2",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ),
                    if (numberofchose >= 3)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                            decoration: InputDecoration(
                                labelText: "Chose 3",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "mustn't be empty";
                              }
                            },
                            controller: option3Controller,
                          ),
                        ),
                      ),
                    if (numberofchose >= 4)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Chose 4",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "mustn't be empty";
                              }
                            },
                            controller: option4Controller,
                          ),
                        ),
                      ),
                    if (numberofchose >= 5)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Chose 5",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "mustn't be empty";
                              }
                            },
                            controller: option5Controller,
                          ),
                        ),
                      )
                  ]),
                if (questionType == "MultipleChoice")
                  SizedBox(
                    height: 70,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.small(
                            onPressed: numberofchose == 5
                                ? null
                                : () {
                                    setState(() {
                                      numberofchose++;

                                    });

                                  },
                            backgroundColor: numberofchose == 5
                                ? Colors.grey
                                : Colors.blueAccent,
                            child: Icon(Icons.add),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton.small(
                            onPressed: numberofchose == 0
                                ? null
                                : () {
                                    setState(() {
                                      numberofchose--;
                                      _remove_choce();
                                    });
                                  },
                            backgroundColor: numberofchose == 0
                                ? Colors.grey
                                : Colors.blueAccent,
                            child: Icon(Icons.remove),
                          ),
                        ]),
                  ),
                SizedBox(
                  height: 14,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Question Grade",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10))),
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
                        decoration: InputDecoration(
                            labelText: "Question Answer",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10))),
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
                            setQuestion();
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
  void _remove_choce() {
    if(numberofchose==0){
      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();
      option5Controller.clear();
    } if(numberofchose==1){
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();
      option5Controller.clear();
    } if(numberofchose==2){
      option3Controller.clear();
      option4Controller.clear();
      option5Controller.clear();
    } if(numberofchose==3){
      option4Controller.clear();
      option5Controller.clear();
    } if(numberofchose==4){
      option5Controller.clear();
    }
  }
}

