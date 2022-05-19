import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:mobileintro/StudentPages/AnswerQuestion.dart';
import 'package:mobileintro/StudentPages/StudentLogin.dart';
import 'package:mobileintro/TeacherPages/TeacherLogin.dart';
import 'package:mobileintro/Storage/storage.dart';

import 'TeacherPages/TeacherHome.dart';

const routeHome = '/';
const routeTeacher = '/teacher';
const routeStudent = '/student';
const routeManageStudents = '/teacher/students';
const routeManageQuestions = '/teacher/questions';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-xam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'E-xam'),
      onGenerateRoute: (settings) {
        late Widget page;
        switch (settings.name) {
          case routeHome:
            page = const MyHomePage(title: "E-xam");
            break;
          case routeTeacher:
            page = const TeacherLogin();
            break;
          case routeStudent:
            page = const StudentLogin();
            break;
          case routeManageStudents:
            page = const MyHomePage(title: "E-xam");
            break;
          case routeManageQuestions:
            page = const MyHomePage(title: "E-xam");
            break;

          default:
            page = const MyHomePage(title: "E-xam");
            break;
        }
        return MaterialPageRoute<dynamic>(
          builder: (context) {
            return page;
          },
          settings: settings,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _navigateTeacher() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeacherLogin()),
    );
  }

  void _navigateStudent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MyScaffold(
      body: Stack(children: [
        Container(height: double.infinity,width: double.infinity, decoration:  BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage("images/background.PNG") )),),
        Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                width: 900,
                child: TextButton(
                  onPressed: _navigateTeacher,
                  child: const Text('Teacher',style: TextStyle(fontSize: 26),),
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 100,
                width: 900,
                child: TextButton(
                  onPressed: _navigateStudent,
                  child: const Text('Student',style: TextStyle(fontSize: 26),),
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      body: Center(
        child: SizedBox(width: 300, child: MyStatefulWidget()),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String? dropdownValue;

  List<Student> students = [];
  void _navigateAnswerQuestion(int studentnumber) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnswerQuestion(studentnumber: studentnumber)),
    );
  }

  @override
  void initState() {
    Storage().getStudents().then((students) => {
          if (mounted) {
              setState(() {
                this.students = students;
              })
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child:
                DropdownButtonFormField<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: students.map((e) => DropdownMenuItem(
                    value: e.number.toString(),
                    child: Text(e.number.toString() + ": " + e.name),
                  )).toList(),
                  validator: (value) {
                    if (value == null || value == "") {
                      return 'Please enter a valid studentnumber';
                    }
                    return null;
                  },
                ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _navigateAnswerQuestion(int.parse(dropdownValue!));
                  }
                },
                child: const Text('Continue'),
            )
          ],
        )
    );
  }
}

class _MyAppBarState extends State<MyAppBar> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return AppBar(
      leading: Navigator.canPop(context) ? const BackButton() : null,
      title: const Text('E-xam'),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class MyScaffold extends StatelessWidget {
  final Widget body;

  const MyScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: MyAppBar(),
        ),
        body: body);
  }
}
