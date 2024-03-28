// ignore_for_file: avoid_print

import 'package:path/path.dart';
import 'package:profile_app/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //store database name auth.db in databasename variable
  final databasename = "auth.db";

//create table with required column name and store in string named 'user'
  String user = '''
CREATE TABLE users(
  userid INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  username TEXT UNIQUE,
  password TEXT,
  phone TEXT,
  dob TEXT,
  gender TEXT,
  imagePath TEXT
);
''';

//create connection between db and execute query to ready table with the specific columns defined
//Our connection is ready
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databasename);

    return openDatabase(path, version: 1, onCreate: ((db, version) async {
      await db.execute(user);
    }));
  }

  //1)//Functions to perform auth,
  //2)//create new user with required details
  //3)//get current user detail to show on profile screen
  //4)//delete the auth user from database...

  //1)method for Authentication purpose
  Future<bool> authentication(userModel user) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "SELECT * FROM users WHERE username='${user.username}' AND password='${user.password}'");
    print(result.toString());

    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //2)method for create new user/Sign up purpose
  Future<int> createUser(userModel user) async {
    final Database db = await initDB();
    return db.insert('users', user.toJson());
  }

  //3)method for Get current authenticated user details purpose like his email,username,password etc....
  Future<userModel?> getUserData(String username) async {
    final Database db = await initDB();
    var res =
        await db.query('users', where: "username=?", whereArgs: [username]);
    return res.isNotEmpty ? userModel.fromJson(res.first) : null;
  }

  //4)method for delete/sign out  the authenticated user from db purpose based of userid
  Future<void> deleteUser(int userid) async {
    final Database db = await initDB();
    await db.delete('users', where: "userid=?", whereArgs: [userid]);
    db.close();
  }

  //method for update the current user record/user model  based on userid...
  Future<void> updateUser(userModel user) async {
    final Database db = await initDB();
    await db.update(
      'users',
      user.toJson(),
      where: 'userid = ?',
      whereArgs: [user.userid],
    );
  }
}
