import 'dart:convert';

import 'package:education/todo/add_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
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
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value){
                      if(value == 'edit') {
                        // Open Edit Page
                        navigateToEditPage(item);
                      }else if(value == 'delete'){
                        //Delete and refresh
                        deleteById(id);
                      }
                    },
                    itemBuilder: (context){
                      return [
                        PopupMenuItem(child: Text('Засах'),
                        value: 'edit',),
                        PopupMenuItem(child: Text('Устгах'),
                        value: 'delete',),
                      ];
                    },
                  ),
                ),
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
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if(response.statusCode == 200) {
      //Remove item from the list
     final filtered =  items = items.where((element) => element['_id'] != id).toList();

     setState(() {
       items = filtered;
     });

    }else {
      // show error
      showErrorMessage('Deletion Failed');
    }
    // Remove item from the list

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

  Future<void> fetchTodo() async {

    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";

    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if(response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;

      setState(() {
        items = result;
      });
    }

  }
}
