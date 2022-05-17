import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class QuestionGrade {
  String question;
  dynamic answer;
  dynamic currentAnswer;
  double maxGrade;

  QuestionGrade(this.question, this.answer, this.currentAnswer, this.maxGrade);

  double get currentGrade {
    if (currentAnswer == answer) {
      return maxGrade;
    }
    return 0;
  }

  StatefulWidget getWidget();
}

class CodeCorrectionGrade extends QuestionGrade {
  String input;

  CodeCorrectionGrade(String question, this.input, String answer, String? currentAnswer, double maxGrade) :
        super(question, answer, currentAnswer, maxGrade);

  @override
  StatefulWidget getWidget() {
    return CodeCorrectionGradeWidget(key: ObjectKey(this), question: this);
  }
}

class CodeCorrectionGradeWidget extends StatefulWidget {
  final CodeCorrectionGrade question;

  const CodeCorrectionGradeWidget({Key? key, required this.question}) : super(key: key);

  @override
  _CodeCorrectionGradeWidgetState createState() => _CodeCorrectionGradeWidgetState();
}

class _CodeCorrectionGradeWidgetState extends State<CodeCorrectionGradeWidget> {
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
          enabled: false,
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
    super.dispose();
  }
}

class MultipleChoiceGrade extends QuestionGrade {
  List<String> input;

  MultipleChoiceGrade(String question, this.input, int answer, int? currentAnswer, double maxGrade) :
        super(question, answer, currentAnswer, maxGrade);

  @override
  StatefulWidget getWidget() {
    return MultipleChoiceGradeWidget(key: ObjectKey(this), question: this);
  }
}

class MultipleChoiceGradeWidget extends StatefulWidget {
  final MultipleChoiceGrade question;

  const MultipleChoiceGradeWidget({Key? key, required this.question}) : super(key: key);

  @override
  _MultipleChoiceGradeWidgetState createState() => _MultipleChoiceGradeWidgetState();
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
        Form(child:
        TextFormField(
          enabled: false,
          initialValue: widget.question.currentAnswer,
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
    super.dispose();
  }
}

class OpenGrade extends QuestionGrade {

  OpenGrade(String question, String? answer, String? currentAnswer, double maxGrade) :
        super(question, answer, currentAnswer, maxGrade);

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
        Form(child:
        TextFormField(
          enabled: false,
          initialValue: widget.question.currentAnswer,
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
    super.dispose();
  }
}