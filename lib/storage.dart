import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> setStudents(Map<int, String> students) async {
    final prefs = await SharedPreferences.getInstance();

    var studentNames = <String>[];
    var studentNumbers = <String>[];

    for (int key in students.keys) {
      studentNames.add(students[key]!);
      studentNumbers.add(key.toString());
    }

    await prefs.setStringList("StudentNumbers", studentNumbers);
    await prefs.setStringList("StudentNames", studentNames);

    return;
  }

  static Future<Map<int, String>> getStudents() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> numbers = prefs.getStringList("StudentNumbers")!.toList();
    final List<String> names = prefs.getStringList("StudentNames")!.toList();

    var students = <int, String>{};

    log(numbers.length.toString());
    log(names.length.toString());

    if (numbers.length != names.length) {
      throw Exception("StudentName length not equal to StudentNumber length");
    }

    for (var i = 0; i < numbers.length; i++) {
      students[int.parse(numbers[i])] = names[i];
    }

    return students;
  }
}

class StudentObject{
  int studentNumber;
  String name;

  StudentObject(this.studentNumber, this.name);
}