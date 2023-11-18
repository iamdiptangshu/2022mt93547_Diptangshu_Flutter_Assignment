import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'UQ36anfIqFGmih96P527CqLogpu1LKMMy4rC3Vlz';
  final keyClientKey = 'QRPZHxnIGrNwWxqyAeSVfa72LFrVMDBUX5JXoang';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoController = TextEditingController();
  final descriptionController = TextEditingController();

  void addToDo() async {
    if (todoController.text.trim().isEmpty || descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Title and description cannot be empty "),
        duration: Duration(seconds: 3),
      ));
      return;
    }
    await saveTodo(todoController.text,descriptionController.text);
    setState(() {
      todoController.clear();
      descriptionController.clear();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parse Todo List Assignment"),
        backgroundColor: Colors.pink.shade300,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                      TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: todoController,
                      decoration: InputDecoration(
                          labelText: "New todo",
                          labelStyle: TextStyle(color: Colors.pink.shade300),
                    ),
                  ),
		   TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: descriptionController,
                      decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(color: Colors.pink.shade300),
                    ),
                  ),
                ],
              ),
            ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.pink,
                      ),
                      onPressed: addToDo,
                      child: Text("ADD "),
                 ),
                ],
              ),
            ),
          Expanded(
              child: FutureBuilder<List<ParseObject>>(
                  future: getTodo(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(),
                         ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error..."),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("No Data..."),
                          );
                        } else {
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 10.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                //*************************************
	                        //Get Parse Object Values
	                        final varTodo = snapshot.data![index];
	                        final varTitle = varTodo.get<String>('title')!;
                                final description = varTodo.get<String>('description')!;
	                        final varDone =  varTodo.get<bool>('done')!;
	                        //*************************************  

                                return ListTile(
                                  title: Text(varTitle),
                                  subtitle: Text(description),
                                  leading: CircleAvatar(
                                    child: Icon(
                                        varDone ? Icons.check : Icons.error),
                                    backgroundColor:
                                        varDone ? Colors.green : Colors.yellow,
                                    foregroundColor: Colors.white,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                          value: varDone,
                                          onChanged: (value) async {
                                            await updateTodo(
                                                varTodo.objectId!, value!);
                                            setState(() {
                                              //Refresh UI
                                            });
                                          }),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.pink,
                                        ),
                                        onPressed: () async {
                                          await deleteTodo(varTodo.objectId!);
                                          setState(() {
                                            final snackBar = SnackBar(
                                              content: Text("Todo deleted!"),
                                              duration: Duration(seconds: 2),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }
                     },
                   ),
                ),
        ],
      ),
    );
  }

  Future<void> saveTodo(String title, String description) async {
    final todo = ParseObject('Todo')
      ..set('title', title)
      ..set('description', description)
      ..set('done', false);
   
    await todo.save();
  }

  Future<List<ParseObject>> getTodo() async {
     QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('Todo'));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTodo(String id, bool done) async {
    var todo = ParseObject('Todo')
      ..objectId = id
      ..set('done', done);
    await todo.save();
  }

  Future<void> deleteTodo(String id) async {
    var todo = ParseObject('Todo')..objectId = id;
    await todo.delete();
  }
}