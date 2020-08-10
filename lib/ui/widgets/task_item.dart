
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_database/models/task_model.dart';
import 'package:todo_database/providers/db_provider.dart';

class TaskItem extends StatelessWidget {
  Task task;
  TaskItem(this.task);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dismissible(
      key: ObjectKey(task),
      /*-onDismissed: (direction) {
        Provider.of<DBProvider>(context, listen: false).deleteTask(task);
      },*/
      child: Card(
        child: ListTile(
        leading: IconButton(icon: Icon(Icons.delete), onPressed: (){
       Provider.of<DBProvider>(context,listen: false).deleteTask(task);
     }),
          title: Text(task.title),
          trailing: Checkbox(
            value: task.isComplete,
            onChanged: (value) {
              Provider.of<DBProvider>(context, listen: false).updateTask(task);
            },
          ),
        ),
      ),
    );
  }
}
