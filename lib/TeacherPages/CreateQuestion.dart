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
  int multipleChoiceCorrectionAnswer = 0;
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
        List<String> options = [];
        for (int i = 0; i < 5; i++) {
          if (optionControllers[i].text != "") {
            options.add(optionControllers[i].text);
          }
        }
        Storage().setMultipleChoiceQuestion(
            questionNumber,
            MultipleChoiceQuestion(
                questionNumber,
                questionController.text,
                0,
                options,
                multipleChoiceCorrectionAnswer,
                0), double.parse(questionGradeController.text));
        break;
    }
    questionNumber++;
    questionController.clear();
    questionGradeController.clear();
    questionAnswerController.clear();
    for (var controller in optionControllers) {
      controller.clear();
    }
    questionType = null;
  }

  String? questionType;
  var questionController = TextEditingController();

  //var q_n = TextEditingController();
  var questionAnswerController = TextEditingController();
  var questionGradeController = TextEditingController();
  List<TextEditingController> optionControllers = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];
  var formkey = GlobalKey<FormState>();

  int amountOfOptions = 2;

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
                    items: const [
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
                        labelText: "The code to be corrected ",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Cannot be empty";
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
                if (questionType == "MultipleChoice")
                  Row(children: [
                    for (int i = 0; i < amountOfOptions; i++)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Radio(
                              value: i,
                              onChanged: (int? value) {
                                setState(() {
                                  multipleChoiceCorrectionAnswer = value!;
                                });
                                },
                              groupValue: multipleChoiceCorrectionAnswer,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {

                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Cannot be empty";
                                  }
                                },
                                controller: optionControllers[i],
                                decoration: InputDecoration(
                                    labelText: "Option " + (i + 1).toString(),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10))),
                              ),
                            ),
                          ],
                          )
                      ),
                  ]),
                if (questionType == "MultipleChoice")
                  SizedBox(
                    height: 70,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.small(
                            onPressed: amountOfOptions >= 5
                                ? null
                                : () {
                                    setState(() {
                                      amountOfOptions++;
                                    });

                                  },
                            backgroundColor: amountOfOptions >= 5
                                ? Colors.grey
                                : Colors.blueAccent,
                            child: Icon(Icons.add),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton.small(
                            onPressed: amountOfOptions <= 2
                                ? null
                                : () {
                                    setState(() {
                                      amountOfOptions--;
                                    });
                                  },
                            backgroundColor: amountOfOptions <= 2
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
                    double? temp = double.tryParse(value!);
                    if (temp == null) {
                      return "Not a valid number";
                    }
                    return null;
                  },
                  onChanged: (value) => formkey.currentState!.validate(),
                  controller: questionGradeController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 33,
                ),
                if (questionType != "MultipleChoice")
                TextFormField(
                        decoration: InputDecoration(
                            labelText: "Question Answer",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
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
}

