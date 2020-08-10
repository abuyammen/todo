
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_database/models/task_model.dart';
import 'package:todo_database/providers/db_provider.dart';
import 'package:todo_database/ui/screens/tabs_screens/all_tasks_tab.dart';
import 'package:todo_database/ui/screens/tabs_screens/complete_task.dart';
import 'package:todo_database/ui/screens/tabs_screens/in_complete_task_tab.dart';

class MainScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey();
  String title;
  String description;
  setTitle(String value) {
    this.title = value;
  }

  setDescription(String value) {
    this.description = value;
  }

  submitTask(BuildContext context) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      try {
        Provider.of<DBProvider>(context, listen: false).insertNewTask(Task(
          title: this.title,
        ));
        Navigator.pop(context);
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(error.toString()),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ok'))
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('TODO'),
            bottom: TabBar(tabs: [
              Tab(
                text: 'All Tasks',
              ),
              Tab(
                text: 'complete Tasks',
              ),
              Tab(
                text: 'inComplete Tasks',
              )
            ]),
            actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete,
              color: Colors.white70,
              size: 30.0,),
              onPressed: () {
                Provider.of<DBProvider>(context, listen: false).deleteAllTasks();
              },
            ),
            SizedBox(
              width: 10,
            )
          ],
          ),
          body: FutureBuilder<List<Task>>(
            future: Provider.of<DBProvider>(context).setAllLists(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TabBarView(children: [
                  AllTasksTab(),
                  CompleteTasksTab(),
                  InCompleteTasksTab()
                ]);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(16.0),
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'text title is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                        fillColor: Colors.grey[200],
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onSaved: (value) {
                        setTitle(value);
                      },
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    new FlatButton(
                        child: const Text('AddTask'),
                        onPressed: () {
                          submitTask(context);
                        })
                  ],
                );
              },
            );
          },
        ),
          /*floatingActionButton: FloatingActionButton(onPressed: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Form(
                      key: formKey,
                      child: CupertinoActionSheet(
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            onPressed: () {},
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: TextFormField(
                                validator: (value) {
                                  // ignore: missing_return
                                  if (value.isEmpty) {
                                    return 'text title is required';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                onSaved: (value) {
                                  setTitle(value);
                                },
                              ),
                            ),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              submitTask(context);
                            },
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: TextFormField(
                                validator: (value) {
                                  // ignore: missing_return
                                  if (value.isEmpty) {
                                    return 'text description is required';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                onSaved: (value) {
                                  setDescription(value);
                                },
                              ),
                            ),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            submitTask(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('Submit'),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                context: context);
          }),*/
        ));
  }
}
