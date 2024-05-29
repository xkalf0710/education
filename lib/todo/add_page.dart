import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  bool isEdit = false;

  @override

  void initState(){
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo": "Add Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: isEdit ? updateData:  submitData,
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(isEdit ? 'Update': 'Submit'),
          ),
          ),
        ],
      ),
    );
  }

  //put request
  Future<void> updateData() async {
    //https://api.nstack.in/v1/todos/6656c78935cb2330822c8464
    //get the data from


    final todo = widget.todo;
    if (todo == null){
      print("You can not call updated without todo data");
      return;
    }
    final id = todo['_id'];
    final isCompleted = todo['is_completed'];
    final title = titleController.text;
    final description = descController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    //submit data to the server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await  http.put(uri, body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if(response.statusCode == 200){
      showSuccessMessage('Амжилттай');
    }else{
      showErrorMessage('Амжилтгүй алдаа гарлаа');
    }
  }
  Future<void> submitData() async {
    //get the data from
    final title = titleController.text;
    final description = descController.text;

    final body = {
      "title": title, 
      "description": description,
      "is_completed": false,
    };
    //submit data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
   final response = await  http.post(uri, body: jsonEncode(body),
   headers: {
     'Content-Type': 'application/json'
   },

   );

    //show success or fail message based on status
    if(response.statusCode == 201){
      titleController.text = '';
      descController.text = '';
      showSuccessMessage('Амжилттай');
    }else{
      showErrorMessage('Амжилтгүй алдаа гарлаа');
    }
  }

  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message){
    final snackBar = SnackBar(content: Text(message,
    style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

