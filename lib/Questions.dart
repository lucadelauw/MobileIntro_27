import 'dart:developer';

import 'package:flutter/material.dart';

abstract class Question {
  String question = '';
  Question(this.question);
  StatefulWidget getWidget(ObjectKey key);
}

class CodeCorrectionQuestion implements Question{
  @override
  String question;
  @override

  String input = "";
  String answer = "";
  String? currentAnswer;

  CodeCorrectionQuestion(this.question, this.input, this.answer, this.currentAnswer);

  @override
  StatefulWidget getWidget(ObjectKey key) {
    return CodeCorrectionWidget(key: key, question: CodeCorrectionQuestion(question, input, answer, this.currentAnswer));
  }
}

class CodeCorrectionWidget extends StatefulWidget {
  final CodeCorrectionQuestion question;

  const CodeCorrectionWidget({Key? key, required this.question}) : super(key: key);

  @override
  _CodeCorrectionWidgetState createState() => _CodeCorrectionWidgetState();
}

class _CodeCorrectionWidgetState extends State<CodeCorrectionWidget> {
  var controller = TextEditingController();
  String initvalue = "";

  @override
  void initState() {
    widget.question.currentAnswer == null ? initvalue = widget.question.input : initvalue = widget.question.currentAnswer!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.question.question),
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
        )
      ],
    );
  }
}

class OpenQuestion implements Question {
  @override
  String question;
  @override

  String? answer = "";
  String? currentAnswer;

  OpenQuestion(this.question, this.answer, this.currentAnswer);

  @override
  StatefulWidget getWidget(ObjectKey key) {
    return OpenQuestionWidget(key: key, question: OpenQuestion(question, answer, currentAnswer));
  }
}

class OpenQuestionWidget extends StatefulWidget {
  final OpenQuestion question;

  const OpenQuestionWidget({Key? key, required this.question}) : super(key: key);

  @override
  _OpenQuestionWidgetState createState() => _OpenQuestionWidgetState();
}

class _OpenQuestionWidgetState extends State<OpenQuestionWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.question.question),
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
}

class MultipleChoiceQuestion implements Question {
  @override
  String question;
  @override

  List<String> input = [];
  int answer = 0;
  int? currentAnswer = -1;

  MultipleChoiceQuestion(this.question, List<dynamic> input, this.answer, this.currentAnswer) {
    input.forEach((element) {
      this.input.add(element.toString());
    });

    if (answer >= input.length || answer < 0) {
      throw("MultipleChoiceQuestion answer invalid index");
    }
  }

  @override
  StatefulWidget getWidget(ObjectKey key) {
    return MultipleChoiceWidget(key: key, question: MultipleChoiceQuestion(question, input, answer, currentAnswer));
  }
}

class MultipleChoiceWidget extends StatefulWidget {
  final MultipleChoiceQuestion question;

  const MultipleChoiceWidget({Key? key, required this.question}) : super(key: key);

  @override
  _MultipleChoiceWidgetState createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.question.question),
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
}