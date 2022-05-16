import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobileintro/storage.dart';

class CsvReader {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlatformFile>? _paths;
  String? _extension="csv";
  FileType _pickingType = FileType.custom;

  Future<List<StudentWithPassword>> getStudents() async {

    List<StudentWithPassword> students = [];
    try {
      log("try");

      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        withData: true
      ))
          ?.files;
      final fields = utf8.decode(_paths!.single.bytes!.toList());
      RegExp(r'[0-9]{6};.+').allMatches(fields).forEach((element) {
        if (element.group(0)!.split(";").length == 2) {
          students.add(StudentWithPassword(int.parse(element.group(0)!.split(";")[0]), element.group(0)!.split(";")[1], ""));
        } else if (element.group(0)!.split(";").length == 3) {
        students.add(StudentWithPassword(int.parse(element.group(0)!.split(";")[0]), element.group(0)!.split(";")[1], element.group(0)!.split(";")[2]));
        } else {
          throw("Invalid CSV");
        }
      });
      
      return students;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }

    return students;
  }
}