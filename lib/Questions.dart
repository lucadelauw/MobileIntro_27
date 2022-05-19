import 'dart:async';
import 'dart:developer';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter/material.dart';
import 'package:mobileintro/Storage/storage.dart';

abstract class Question {
  int questionnumber;
  String question;
  int studentnumber;
  dynamic currentAnswer;
  Question(this.questionnumber, this.question, this.studentnumber, this.currentAnswer);
  StatefulWidget getWidget(ObjectKey key);
  StatefulWidget getEditWidget(ObjectKey key);
}

class CodeCorrectionQuestion extends Question{

  String input = "";
  String answer = "";


  CodeCorrectionQuestion(int questionNumber, String question, int studentNumber, this.input, this.answer, String? currentAnswer) :
    super(questionNumber, question, studentNumber, currentAnswer);

  @override
  StatefulWidget getWidget(ObjectKey key) {
    return CodeCorrectionWidget(key: key, question: this);
  }
  @override
  StatefulWidget getEditWidget(ObjectKey key) {
    return CodeCorrectionWidget(key: key, question: this);
  }
}

class CodeCorrectionWidget extends StatefulWidget {
  final CodeCorrectionQuestion question;

  const CodeCorrectionWidget({Key? key, required this.question}) : super(key: key);

  @override
  _CodeCorrectionWidgetState createState() => _CodeCorrectionWidgetState();
}

class _CodeCorrectionWidgetState extends State<CodeCorrectionWidget> {
  StreamSubscription<FGBGType>? subscription;
  String initvalue = "";
  int timesGoneToBackground = 0;

  @override
  void initState() {
    subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        timesGoneToBackground++;
        print(timesGoneToBackground);
      }// FGBGType.foreground or FGBGType.background
    });
    widget.question.currentAnswer == null ? initvalue = widget.question.input : initvalue = widget.question.currentAnswer!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            widget.question.question,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        Form(child:
        TextFormField(
          initialValue: initvalue,
          decoration: const InputDecoration(
              labelText: 'Answer'
          ),
          onChanged: (value) => {
            widget.question.currentAnswer = value
          },
        ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    Storage().setAnswer(widget.question.studentnumber, widget.question.questionnumber, widget.question.currentAnswer, timesGoneToBackground);
    super.dispose();
  }
}

class OpenQuestion extends Question {

  String? answer = "";

  OpenQuestion(int questionNumber, String question, int studentNumber, this.answer, String? currentAnswer) :
        super(questionNumber, question, studentNumber, currentAnswer);

  @override
  StatefulWidget getWidget(ObjectKey key) {
    return OpenQuestionWidget(key: key, question: this);
  }
  @override
  StatefulWidget getEditWidget(ObjectKey key) {
    return OpenQuestionWidget(key: key, question: this);
  }
}

class OpenQuestionWidget extends StatefulWidget {
  final OpenQuestion question;

  const OpenQuestionWidget({Key? key, required this.question}) : super(key: key);

  @override
  _OpenQuestionWidgetState createState() => _OpenQuestionWidgetState();
}

class _OpenQuestionWidgetState extends State<OpenQuestionWidget> {
  StreamSubscription<FGBGType>? subscription;
  int timesGoneToBackground = 0;

  @override
  void initState() {
    subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        timesGoneToBackground++;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            widget.question.question,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        Form(child:
        TextFormField(
          initialValue: widget.question.currentAnswer,
          decoration: const InputDecoration(
              labelText: 'Answer'
          ),
          onChanged: (value) => {
            widget.question.currentAnswer = value
          },
        ),
        )
      ],
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    Storage().setAnswer(widget.question.studentnumber, widget.question.questionnumber, widget.question.currentAnswer, timesGoneToBackground);
    super.dispose();
  }
}

class MultipleChoiceQuestion extends Question {

  List<String> input;
  int answer;
  @override
  covariant int? currentAnswer;

  MultipleChoiceQuestion(int questionNumber, String question, int studentNumber, this.input, this.answer, this.currentAnswer) :
    super(questionNumber, question, studentNumber, currentAnswer){
      if (answer >= input.length || answer < 0) {
        throw("MultipleChoiceQuestion answer invalid index");
      }
  }

  @override
  StatefulWidget getWidget(ObjectKey key) {
    return MultipleChoiceWidget(key: key, question: this);
  }
  @override
  StatefulWidget getEditWidget(ObjectKey key) {
    return MultipleChoiceWidget(key: key, question: this);
  }
}

class MultipleChoiceWidget extends StatefulWidget {
  final MultipleChoiceQuestion question;

  const MultipleChoiceWidget({Key? key, required this.question}) : super(key: key);

  @override
  _MultipleChoiceWidgetState createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  StreamSubscription<FGBGType>? subscription;
  int timesGoneToBackground = 0;

  @override
  void initState() {
    subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        timesGoneToBackground++;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            widget.question.question,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        for (int i = 0; i < widget.question.input.length; i ++)
          ListTile(
            title: Text(widget.question.input[i]),
            leading: Radio(
              value: i,
              groupValue: widget.question.currentAnswer,
              onChanged: (int? value) {
                setState(() {
                  widget.question.currentAnswer = value;
                });
              },
              activeColor: Colors.green,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    Storage().setAnswer(widget.question.studentnumber, widget.question.questionnumber, widget.question.currentAnswer, timesGoneToBackground);
    super.dispose();
  }
}