import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileintro/Storage/storage.dart';

abstract class QuestionGrade {
  int questionNumber;
  int studentNumber;
  String question;
  dynamic answer;
  dynamic currentAnswer;
  double maxGrade;
  double currentGrade;

  QuestionGrade(this.questionNumber, this.studentNumber, this.question, this.answer, this.currentAnswer, this.maxGrade,
      this.currentGrade);

  StatefulWidget getWidget();
}

class CodeCorrectionGrade extends QuestionGrade {
  String input;

  CodeCorrectionGrade(int questionNumber, int studentNumber, String question, this.input, String answer,
      String? currentAnswer, double maxGrade, double currentGrade)
      : super(questionNumber, studentNumber, question, answer, currentAnswer, maxGrade, currentGrade);

  @override
  StatefulWidget getWidget() {
    return CodeCorrectionGradeWidget(key: ObjectKey(this), question: this);
  }
}

class CodeCorrectionGradeWidget extends StatefulWidget {
  final CodeCorrectionGrade question;

  const CodeCorrectionGradeWidget({Key? key, required this.question})
      : super(key: key);

  @override
  _CodeCorrectionGradeWidgetState createState() =>
      _CodeCorrectionGradeWidgetState();
}

class _CodeCorrectionGradeWidgetState extends State<CodeCorrectionGradeWidget> {
  String initvalue = "";
  TextEditingController newScoreController = TextEditingController();
  final _newScoreForm = GlobalKey<FormState>();

  @override
  void initState() {
    newScoreController.text = widget.question.currentGrade.toString();
    widget.question.currentAnswer == null
        ? initvalue = widget.question.input
        : initvalue = widget.question.currentAnswer!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.question.question),
          TextFormField(
            enabled: false,
            initialValue: widget.question.currentAnswer,
            decoration: const InputDecoration(labelText: 'Answer'),
            onChanged: (value) => {widget.question.currentAnswer = value},
          ),
          Row(
            children: [
              Container(
                width: 200,
                child: Form(
                  key: _newScoreForm,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: newScoreController ,
                    decoration: const InputDecoration(labelText: 'New Score'),
                    validator: (value) {
                      double? temp = double.tryParse(value!);
                      if (temp == null) {
                        return "Not a valid number";
                      }
                      if (temp > widget.question.maxGrade) {
                        return "Can't be bigger than maximum grade";
                      }
                      return null;
                    },
                    onChanged: (value) {_newScoreForm.currentState!.validate();},
                  ),
                ),
              ),
              Expanded(
                  child: Text(" / " + widget.question.maxGrade.toString())
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (_newScoreForm.currentState!.validate()) {
                      Storage().setNewScore(widget.question.questionNumber, widget.question.studentNumber, double.parse(newScoreController.text));
                      setState(() {
                        widget.question.currentGrade = double.parse(newScoreController.text);
                      });
                    }
                  },
                  child: Container(
                    child: const Center(
                      child: Text(
                        "Set Score",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    margin: const EdgeInsets.all(18),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          )
        ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MultipleChoiceGrade extends QuestionGrade {
  List<String> input;

  MultipleChoiceGrade(int questionNumber, int studentNumber, String question, this.input, int answer,
      int? currentAnswer, double maxGrade, double currentGrade)
      : super(questionNumber, studentNumber, question, answer, currentAnswer, maxGrade, currentGrade);

  @override
  StatefulWidget getWidget() {
    return MultipleChoiceGradeWidget(key: ObjectKey(this), question: this);
  }
}

class MultipleChoiceGradeWidget extends StatefulWidget {
  final MultipleChoiceGrade question;

  const MultipleChoiceGradeWidget({Key? key, required this.question})
      : super(key: key);

  @override
  _MultipleChoiceGradeWidgetState createState() =>
      _MultipleChoiceGradeWidgetState();
}

class _MultipleChoiceGradeWidgetState extends State<MultipleChoiceGradeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.question.question),
        for (int i = 0; i < widget.question.input.length; i++)
          ListTile(
            title: Text(widget.question.input[i]),
            leading: Radio(
              value: i,
              groupValue: i == widget.question.currentAnswer ? i : -1,
              onChanged: (value) {},
              activeColor:
                  i == widget.question.answer ? Colors.green : Colors.red,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class OpenGrade extends QuestionGrade {
  OpenGrade(int questionNumber, int studentNumber, String question, String? answer, String? currentAnswer,
      double maxGrade, double currentGrade)
      : super(questionNumber, studentNumber, question, answer, currentAnswer, maxGrade, currentGrade);

  @override
  StatefulWidget getWidget() {
    return OpenGradeWidget(key: ObjectKey(this), question: this);
  }
}

class OpenGradeWidget extends StatefulWidget {
  final OpenGrade question;

  const OpenGradeWidget({Key? key, required this.question}) : super(key: key);

  @override
  _OpenGradeWidgetState createState() => _OpenGradeWidgetState();
}

class _OpenGradeWidgetState extends State<OpenGradeWidget> {

  TextEditingController newScoreController = TextEditingController();
  final _newScoreForm = GlobalKey<FormState>();

  @override
  void initState() {
    newScoreController.text = widget.question.currentGrade.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.question.question),
          TextFormField(
            enabled: false,
            initialValue: widget.question.currentAnswer,
            decoration: const InputDecoration(labelText: 'Answer'),
            onChanged: (value) => {widget.question.currentAnswer = value},
          ),
          Row(
            children: [
              Container(
                width: 200,
                child: Form(
                  key: _newScoreForm,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: newScoreController ,
                    decoration: const InputDecoration(labelText: 'New Score'),
                    validator: (value) {
                      double? temp = double.tryParse(value!);
                      if (temp == null) {
                        return "Not a valid number";
                      }
                      if (temp > widget.question.maxGrade) {
                        return "Can't be bigger than maximum grade";
                      }
                      return null;
                    },
                    onChanged: (value) {_newScoreForm.currentState!.validate();},
                  ),
                ),
              ),
              Expanded(
                child: Text(" / " + widget.question.maxGrade.toString())
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (_newScoreForm.currentState!.validate()) {
                      setState(() {
                        widget.question.currentGrade = double.parse(newScoreController.text);
                      });
                      Storage().setNewScore(widget.question.questionNumber, widget.question.studentNumber, double.parse(newScoreController.text));
                    }
                  },
                  child: Container(
                    child: const Center(
                      child: Text(
                        "Set Score",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    margin: const EdgeInsets.all(18),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          )
        ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
