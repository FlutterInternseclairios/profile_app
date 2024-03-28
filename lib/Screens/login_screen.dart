// ignore_for_file: use_build_context_synchronously, avoid_print, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:profile_app/Screens/profile_screen.dart';
import 'package:profile_app/Screens/signup_screen.dart';
import 'package:profile_app/model/user_model.dart';
import 'package:profile_app/reusablebtn.dart';
import 'package:profile_app/sqlitedb/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final db = DatabaseHelper();

//login function we will take user detail
//through textfield to check whether
// details are correct or not to auth the user
  void login() async {
    var res = await db.authentication(userModel(
        username: usernameController.text, password: passwordController.text));
    //if user fill correct detail then go
    //to profile screen
    if (res == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(
                    username: usernameController.text,
                  ))).then((value) {
        usernameController.clear();
        passwordController.clear();
      });
    }
    //otherwise go to this message
    //for incorrect details user
    //enter that don't match any user or user does not exist in db
    else {
      return print("Login field incorrect detail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Already \nhave an\nAccount?",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 300,
                    width: 200,
                    child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/loginlogo.png')),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "username",
                    hintText: "Enter your username",
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ResuableButton(
                      text: "Login",
                      ontap: () {
                        setState(() {
                          isLoading = true;
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        });

                        login();
                      }),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New user? ",
                    style: TextStyle(
                      color: Colors.purple[300],
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                        color: Colors.purple[300],
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
