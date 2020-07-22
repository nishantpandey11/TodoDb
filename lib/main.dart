import 'package:flutter/material.dart';
import 'package:tododb/screens/todolist.dart';
import 'package:tododb/util/dbhelper.dart';

import 'model/todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
 
  @override
  Widget build(BuildContext context) {
    /*DbHelper helper = DbHelper();
    helper.initializeDb();
    DateTime today = DateTime.now();

    for(int i  =1; i <= 3;i++) {
      Todo todo = Todo("Buy Apple " + i.toString(), i, today.toString(),"Good Apple "+i.toString());
      helper.insertTodo(todo);
    }*/

    return MaterialApp(
      title: 'Todos',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
      ),
      body: TodoList(),
    );
  }
}
