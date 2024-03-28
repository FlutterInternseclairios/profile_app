// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/Screens/login_screen.dart';
import 'package:profile_app/model/user_model.dart';
import 'package:profile_app/reusablebtn.dart';
import 'package:profile_app/sqlitedb/database_helper.dart';
import 'dart:io';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

bool isLoading = false;
File? _imageFile;
final TextEditingController usernameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController dobController = TextEditingController();

final db = DatabaseHelper();

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedGender = '';

  //method for selecting image from gallery

  Future<void> _pickimage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    try {
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  //sign up function to create user when user fill required textfields
  // accoridngly and click on Register button tocall this function....
  signup() async {
    String imagePath = '';
    if (_imageFile != null) {
      imagePath = _imageFile!.path;
    }
    var res = await db.createUser(
      userModel(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
          phone: phoneController.text,
          dob: dobController.text,
          gender: selectedGender,
          imagePath: imagePath),
    );
    if (res > 0) {
      print("successfully added user");
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()))
          .then((value) {
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        phoneController.clear();
        dobController.clear();
      });
    } else {
      print("something went wrong to sign up user");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Here's your\nfirst step\n with us!",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 180,
                        width: 150,
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/registorlogo.jpg'),
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _pickimage(ImageSource
                        .gallery); // or ImageSource.camera for capturing image from camera
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[500],
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _imageFile == null
                          ? Icon(
                              Icons.add_a_photo,
                              color: Colors.grey[300],
                              size: 40,
                            )
                          : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      hintText: "Enter your username",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                    ),
                  ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone No",
                      hintText: "Enter your phone number",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: dobController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "DOB",
                      hintText: "Enter date of birth",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text("Select Gender"),
                          Expanded(
                            child: RadioListTile(
                              title: const Text('Male'),
                              value: 'Male',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text('Female'),
                              value: 'Female',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : ResuableButton(
                        text: "Register",
                        ontap: () {
                          setState(() {
                            isLoading = true;
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          });
                          //call signup to create new user
                          signup();
                        }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Existing user? ",
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
                                builder: (context) => const LoginScreen()));
                      },
                      child: Text(
                        "Login Here",
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
      ),
    );
  }
}
