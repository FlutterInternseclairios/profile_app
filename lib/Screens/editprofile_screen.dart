// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/model/user_model.dart';
import 'package:profile_app/reusablebtn.dart';
import 'package:profile_app/sqlitedb/database_helper.dart';

class EditProfileScreen extends StatefulWidget {
  final int userid;
  final userModel? user;
  const EditProfileScreen({
    super.key,
    required this.userid,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

bool isLoading = false;
File? _imageFile;
final TextEditingController usernameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController dobController = TextEditingController();

final db = DatabaseHelper();

class _EditProfileScreenState extends State<EditProfileScreen> {
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

  String selectedGender = '';
  @override
  void initState() {
    // TODO: implement initState/
    super.initState();
    //store all the existing data in textform fields
    usernameController.text = widget.user!.username.toString();
    emailController.text = widget.user!.email.toString();
    passwordController.text = widget.user!.password.toString();
    phoneController.text = widget.user!.phone.toString();
    dobController.text = widget.user!.dob.toString();
    selectedGender = widget.user!.gender.toString();
    if (widget.user!.imagePath != null) {
      setState(() {
        _imageFile = File(widget.user!.imagePath!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _pickimage(
                      ImageSource.gallery); // Open gallery to select new image
                },
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _imageFile == null
                          ? Icon(Icons.add_a_photo, color: Colors.grey[600])
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 30,
                            ),
                            onPressed: () {
                              _pickimage(ImageSource
                                  .gallery); // Open gallery to select new image
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      text: "Save",
                      ontap: () async {
                        String imagePath = '';
                        if (_imageFile != null) {
                          imagePath = _imageFile!.path;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        // Create a new userModel object with updated user details
                        userModel? updatedUser = userModel(
                          userid: widget.userid,
                          username: usernameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          phone: phoneController.text,
                          dob: dobController.text,
                          gender: selectedGender,
                          imagePath: imagePath,
                        );
                        // Update the user
                        await db.updateUser(updatedUser).then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        }).onError((error, stackTrace) {
                          print(error.toString());
                        });
                      }),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
