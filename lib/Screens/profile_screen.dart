// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_app/Screens/editprofile_screen.dart';
import 'package:profile_app/model/user_model.dart';
import 'package:profile_app/sqlitedb/database_helper.dart';

class ProfileScreen extends StatefulWidget {
  final String? username;

  const ProfileScreen({Key? key, this.username}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<userModel?> _userDataFuture;
  final db = DatabaseHelper();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<userModel?> _fetchUserData() async {
    try {
      String username = widget.username!.trim();
      if (username.isNotEmpty) {
        return await db.getUserData(username);
      } else {
        throw 'Username is empty';
      }
    } catch (e) {
      throw 'Error fetching user data: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<userModel?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            userModel userDetails = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 80,
                      backgroundImage: '$userDetails!.imagePath' != null
                          ? FileImage(File(userDetails.imagePath!))
                          : null),
                  const SizedBox(height: 25),
                  ListTile(
                    leading: const Icon(
                      Icons.people,
                      size: 35,
                    ),
                    title: const Text("Username"),
                    subtitle: Text(
                      '${userDetails.username}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.email,
                      size: 35,
                    ),
                    title: const Text("Email"),
                    subtitle: Text(
                      '${userDetails.email}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.lock,
                      size: 35,
                    ),
                    title: const Text("password"),
                    subtitle: Text(
                      '${userDetails.password}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.celebration,
                      size: 35,
                    ),
                    title: const Text("Date of birth"),
                    subtitle: Text(
                      '${userDetails.dob}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.phone,
                      size: 35,
                    ),
                    title: const Text("Phone"),
                    subtitle: Text(
                      '${userDetails.phone}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.male,
                      size: 35,
                    ),
                    title: const Text("Gender"),
                    subtitle: Text(
                      '${userDetails.gender}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                      userid: userDetails.userid!,
                                      user: userDetails,
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });

                                setState(() {
                                  _userDataFuture = _fetchUserData();
                                });
                              },
                              child: const Text('Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                      ElevatedButton(
                        onPressed: () async {
                          await db.deleteUser(userDetails.userid!);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
