import 'package:flutter/material.dart';
import 'package:todo_list/loading.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/database_services.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isComplete = false;
  TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
          stream: DatabaseService().listTodos(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Loading();
            }
            List<Todo>? todos = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('All Todos',style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),),
                    Divider(),
                    SizedBox(height: 20),
                    ListView.separated(
                      separatorBuilder: (context,index){
                       return Divider(color: Colors.grey[800],);
                      },
                      shrinkWrap: true,
                      itemCount: todos!.length,
                        itemBuilder: (context,index){
                        return Dismissible(
                          key: Key(todos[index].title),
                          background: Container(
                            padding: EdgeInsets.only(left: 20.0),
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete),
                            color: Colors.pink,
                          ),
                          onDismissed: (direction) async{
                            await DatabaseService().removeTodo(todos[index].uid);
                          },
                          child: ListTile(
                            onTap: (){
                              DatabaseService().completeTask(todos[index].uid);
                            },
                            leading: Container(
                              child: todos[index].isComplete ? Center(child: Icon(Icons.check,color: Colors.white)) : Container(),
                              height: 25.0,
                              width: 25.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle
                              ),
                            ),
                            title: Text(todos[index].title,style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[200],
                            ),),

                          ),
                        );
                        },
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
              ),
              title: Row(
                children: [
                  Text('Add Todo',style: TextStyle(
                    fontSize: 20.0,
                  ),),
                  Spacer(),
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  },
                      icon: Icon(Icons.cancel,color: Colors.grey,size: 30.0,)),
                ],
              ),
              children: [
                Divider(
                  color: Colors.pink,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _todoController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: Colors.black54
                    ),
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "eg. Rain Dance",
                      border: InputBorder.none
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text("Add"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () async{
                        if(_todoController.text.isNotEmpty){
                          await DatabaseService().createNewTodo(_todoController.text.trim());
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                  ),
                )
              ],
            )
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Center(
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

