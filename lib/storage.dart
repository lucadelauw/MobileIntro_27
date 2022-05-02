import 'dart:developer';
import 'package:mobileintro/firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Storage {

  static bool inited = false;

  static Future<void> setStudents(Map<int, String> students) async {

    if (!inited) {
      await init();
    }

    await FirebaseFirestore.instance.collection('E-xam').doc('students').set(students.map((key, value) => MapEntry(key.toString(), value)));
  }

  static Future<Map<int, String>> getStudents() async {

    if (!inited) {
      await init();
    }

    var students = <int, String>{};

    await FirebaseFirestore.instance.collection('E-xam').doc('students').get().then((value) => {
      students = value.data()!.map((key, value) => MapEntry(int.parse(key), value.toString()))
    });

    return students;
  }

  static Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    return;
  }
}

class StudentObject{
  int studentNumber;
  String name;

  StudentObject(this.studentNumber, this.name);
}