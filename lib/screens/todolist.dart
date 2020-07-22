import 'package:flutter/material.dart';
import 'package:tododb/model/todo.dart';
import 'package:tododb/screens/tododetail.dart';
import 'package:tododb/util/dbhelper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DbHelper helper = DbHelper();
  int count = 0;
  List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var newTodo = Todo("", 3, "");
          newTodo.setScreenName("Add Todo");
          navigateToDetail(newTodo);
        },
        tooltip: "Add a new todo",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.todos[position].getPriority()),
              child: Text(this.todos[position].getPriority().toString()),
            ),
            title: Text(this.todos[position].getTitle()),
            subtitle: Text(this.todos[position].getDate()),
            onTap: () {
              debugPrint(this.todos[position].getId().toString());
              this.todos[position].setScreenName("Edit Todo");
              navigateToDetail(this.todos[position]);
            },
          ),
        );
      },
    );
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.blueAccent;
    }
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((value) {
      final todosFuture = helper.getTodos();
      todosFuture.then((value) {
        List<Todo> todoList = List<Todo>();
        count = value.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(value[i]));
          debugPrint("Id : " + todoList[i].getId().toString());
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("Items : " + count.toString());
      });
    });
  }

  void navigateToDetail(Todo todo) async {
    debugPrint(todo.getTitle());
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));

    if (result == true) {
      getData();
    }
  }
}
