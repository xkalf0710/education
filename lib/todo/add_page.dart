
import 'package:education/services/todo_service.dart';
import 'package:flutter/material.dart';


import '../utils/snackbar_helper.dart';

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


    //submit data to the server

    final isSuccess = await TodoService.updateTodo(id, body);
    if(isSuccess){
      showSuccessMessage(context, message: 'Амжилттай');
    }else{
      showErrorMessage(context, message: 'Алдаа гарлаа');
    }
  }


  Future<void> submitData() async {

    //submit data to the server

   final isSuccess = await  TodoService.addTodo(body);

    //show success or fail message based on status
    if(isSuccess){
      titleController.text = '';
      descController.text = '';
      showSuccessMessage(context, message: 'Амжилттай');
    }else{
      showErrorMessage(context, message: 'Амжилтгүй алдаа гарлаа');
    }
  }
   Map get body {
     final title = titleController.text;
     final description = descController.text;

      return {
       "title": title,
       "description": description,
       "is_completed": false,
     };
   }
}

