import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';


class TeacherHome extends StatelessWidget{
  const TeacherHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void _navigateStudentPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudentPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('E-xam')
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: TextButton(
                onPressed: _navigateStudentPage,
                child: const Text(
                    'Students'
                ),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.red
                ),
              ),
            ),
            SizedBox(
              width: 100,
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: TextButton(
                onPressed: null,
                child: const Text(
                    'Questions'
                ),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.red
                ),
              ),
            ),
            SizedBox(
              width: 100,
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: TextButton(
                onPressed: null,
                child: const Text(
                    'Grades'
                ),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.red
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentPage extends StatelessWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('E-xam')
        ),
        body: Center(
          child: Row(

          )
        )
    );
  }

}