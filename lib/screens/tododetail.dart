import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tododb/model/todo.dart';
import 'package:tododb/util/dbhelper.dart';

DbHelper helper = DbHelper();
final List<String> choices = const <String>[
  'Save Todo & Back',
  'Delete Todo',
  'Back to List'
];
const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete Todo';
const mnuBack = 'Back to List';

class TodoDetail extends StatefulWidget {
  final Todo todo;

  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() {
    debugPrint("TodoDetails : " + todo.getTitle());
    return TodoDetailState(todo);
  }
}

class TodoDetailState extends State<TodoDetail> {
  Todo todo;

  //very imp : this  keyword assigns current t;odo obj to passed one
  // this.to;do = to;do
  TodoDetailState(this.todo);

  final _priorities = ['High', 'Medium', 'Low'];
  String _priority = 'Low';

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.getTitle();
    descriptionController.text = todo.getDescription();
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
        appBar: AppBar(
          title: Text(todo.getScreenName()),
          automaticallyImplyLeading: true, //remove back navigation button
          actions: <Widget>[
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: select,
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //1st child

                  TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) => this.updateTitle(),
                    decoration: InputDecoration(
                        labelStyle: textStyle,
                        labelText: "Title",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  //1 : END

                  //2nd child

                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: descriptionController,
                        style: textStyle,
                        onChanged: (value) => this.updateDescription(),
                        decoration: InputDecoration(
                            labelStyle: textStyle,
                            labelText: "Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),

                  //2: END

                  //3rd child
                  ListTile(
                      title: DropdownButton<String>(
                          items: _priorities.map((String val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),

                          style: textStyle,
                          value: retrivePriority(todo.getPriority()), //_priority,
                          onChanged: (value) => this.updatePriority(value),

                      )
                  )
                  //3 : END
                ],
              )
            ],
          ),
        ));
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (todo.getId() == null) {
          return;
        }
        result = await helper.deleteTodo(todo.getId());
        if (result != 0) {
          AlertDialog dialog = AlertDialog(
            title: Text('Delete Todo'),
            content: Text('The todo has been deleted'),
          );
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    todo.setDate(new DateFormat.yMd().format(DateTime.now()));
    if (todo.getId() != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.setPriority(1);
        break;
      case "Medium":
        todo.setPriority(2);
        break;
      case "Low":
        todo.setPriority(3);
        break;
    }
    setState(() {
      _priority = value;
    });
  }

  String retrivePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    todo.setTitle(titleController.text);
  }

  void updateDescription() {
    todo.setDescription(descriptionController.text);
  }
}
