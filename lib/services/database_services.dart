import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todo.dart';

class DatabaseService {
  CollectionReference todosCollection = FirebaseFirestore.instance.collection(
      'todos');

  Future createNewTodo(String title) async {
    return await todosCollection.add({
      "title": title,
      "isComplete": false,

    });
  }

  Future completeTask(uid) async{
    return await todosCollection.doc(uid).update({"isComplete": true});
  }

  Future removeTodo(uid) async {
    await todosCollection.doc(uid).delete();
  }

  List<Todo> todoFromFireStore(QuerySnapshot snapshot){
    if(snapshot != null){
      return snapshot.docs.map((e){
        return Todo(
          isComplete: e["isComplete"],
          title: e["title"],
          uid: e.id,
        );
      }).toList();
    }else{
      return null!;
    }
  }

  Stream<List<Todo>> listTodos(){
    return todosCollection.snapshots().map(todoFromFireStore);
  }
}