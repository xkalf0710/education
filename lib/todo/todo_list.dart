
import 'package:education/todo/add_page.dart';
import 'package:education/widget/todo_card.dart';
import 'package:flutter/material.dart';
import '../services/todo_service.dart';
import '../utils/snackbar_helper.dart';


class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = false;
List items = [];
  @override

  void initState(){
    super.initState();
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        replacement: Center(child: CircularProgressIndicator(),
        ),
        child: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text('No Todo Item',
              style: Theme.of(context).textTheme.headlineMedium,),
            ),

          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return TodoCard(index: index,
                  item: item,
                  navigateEdit: navigateToEditPage,
                  deleteById: deleteById
              );
            },),
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: navigateToAddPage,
          label: Text('Add Todo')),
    );
  }
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage());
    await  Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

 Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id)async {
    // Delete the item

    final isSuccess = await TodoService.deleteById(id);

    if(isSuccess) {
      //Remove item from the list
     final filtered =  items = items.where((element) => element['_id'] != id).toList();

     setState(() {
       items = filtered;
     });

    }else {
      // show error
      showErrorMessage(context, message:'Deletion Failed');
    }
    // Remove item from the list

  }

  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> fetchTodo() async {

    final response = await  TodoService.fetchTodos();


    if(response != null) {


      setState(() {
        items = response;
      });
    }else{
      showErrorMessage(context, message: 'Something wento wrong');
    }

    setState(() {
      isLoading = false;
    });

  }
}
