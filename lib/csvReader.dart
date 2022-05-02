import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobileintro/storage.dart';

class CsvReader {
  late List<List<dynamic>> employeeData;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlatformFile>? _paths;
  String? _extension="csv";
  FileType _pickingType = FileType.custom;

  Future<Map<int, String>> getStudents() async {

    var students = <int, String>{};
    try {

      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;

      final fields = utf8.decode(_paths!.single.bytes!.toList());
      RegExp(r'[0-9]{6};.+').allMatches(fields).forEach((element) {
        students[int.parse(element.group(0)!.split(";")[0])] = element.group(0)!.split(";")[1];
      });

      log(students.toString());
      return students;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }

    return students;
  }
}