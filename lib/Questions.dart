import 'package:flutter/material.dart';

abstract class Question {
  String question = '';
  Question(this.question);
  StatefulWidget getWidget();
}

class CodeCorrectionQuestion implements Question{
  @override
  String question;
  String input = "";
  String answer = "";

  CodeCorrectionQuestion(this.question, this.input, this.answer);

  @override
  StatefulWidget getWidget() {
    return CodeCorrectionWidget(question: CodeCorrectionQuestion(question, input, answer));
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

  @override
  void initState() {
    controller.text = widget.question.input;
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
          controller: controller,
          decoration: const InputDecoration(
              labelText: 'Answer'
          ),
        ),
        )
      ],
    );
  }
}

class OpenQuestion implements Question {
  @override
  String question;
  String? answer = "";

  OpenQuestion(this.question, this.answer);

  @override
  StatefulWidget getWidget() {
    return OpenQuestionWidget(question: OpenQuestion(question, answer));
  }
}

class OpenQuestionWidget extends StatefulWidget {
  final OpenQuestion question;

  const OpenQuestionWidget({Key? key, required this.question}) : super(key: key);

  @override
  _OpenQuestionWidgetState createState() => _OpenQuestionWidgetState();
}

class _OpenQuestionWidgetState extends State<OpenQuestionWidget> {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.question.question),
        Form(child:
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
              labelText: 'Answer'
          ),
        ),
        )
      ],
    );
  }
}

class MultipleChoiceQuestion implements Question {
  @override
  String question;
  List<String> input = [];
  String answer = "";

  MultipleChoiceQuestion(this.question, List<dynamic> input, this.answer) {
    input.forEach((element) {
      this.input.add(element.toString());
    });

    if (!this.input.contains(answer)) {
      throw("MultipleChoiceQuestion has no correct answer");
    }
  }

  @override
  StatefulWidget getWidget() {
    return MultipleChoiceWidget(question: MultipleChoiceQuestion(question, input, answer));
  }
}

class MultipleChoiceWidget extends StatefulWidget {
  final MultipleChoiceQuestion question;

  const MultipleChoiceWidget({Key? key, required this.question}) : super(key: key);

  @override
  _MultipleChoiceWidgetState createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  int? val = -1;
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
            groupValue: val,
            onChanged: (int? value) {
              setState(() {
                val = value;
              });
            },
            activeColor: Colors.green,
          ),
        ),
      ],
    );
  }
}