import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> setStudents(List<StudentObject> students) async {
    final prefs = await SharedPreferences.getInstance();

    var studentNames = <String>[];
    var studentNumbers = <String>[];

    for (var student in students) {
      studentNames.add(student.name);
      studentNumbers.add(student.studentNumber.toString());
    }

    await prefs.setStringList("StudentNumbers", studentNumbers);
    await prefs.setStringList("StudentNames", studentNames);

    return;
  }

  static Future<List<StudentObject>> getStudents() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> numbers = prefs.getStringList("StudentNumbers")!.toList();
    final List<String> names = prefs.getStringList("StudentNames")!.toList();

    var students = <StudentObject>[];

    log(numbers.length.toString());
    log(names.length.toString());

    if (numbers.length != names.length) {
      throw Exception("StudentName length not equal to StudentNumber length");
    }

    for (var i = 0; i < numbers.length; i++) {
      students.add(StudentObject(int.parse(numbers[i]), names[i]));
    }

    return students;
  }
}

class StudentObject{
  int studentNumber;
  String name;

  StudentObject(this.studentNumber, this.name);
}