import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

 
List _users;
main() async{
  var db = new DatabaseHelper();

//  now lets add the user
  int savedUser = await db.saveUser(new User("Jihn", "abc"));
  print("user $savedUser");

  _users = await db.getAllUsers();

  for(int i=0; i < _users.length; i++){
//    this will convert the list _users into an user object
    User user = User.map(_users[i]);
    print("username: ${user.username}");
  }

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: new Text("Database"),
      ),
    );
  }
}
