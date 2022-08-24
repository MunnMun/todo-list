import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_list/loading.dart';
import 'package:todo_list/todo_list.dart';

 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Loading();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: TodoList(),
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.grey[900],
              primarySwatch: Colors.pink
          ),
        );
      },
    );
  }
}
