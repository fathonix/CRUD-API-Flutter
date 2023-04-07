// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:crud_api_app/locals/secure_storage.dart';
import 'package:crud_api_app/models/user.dart';
import 'package:crud_api_app/services/user_service.dart';
import 'package:crud_api_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late User user;

  void getUser() {
    SecureStorage.getUser().then((value) {
      if (value != null) {
        setState(() {
          user = value;
        });
      }
    });
  }

  @override
  void initState() {
    getUser();
    // if (!mounted) return;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   log('TIME $timeStamp');
    //   getUser();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
        ),
        body: FutureBuilder(
          initialData: null,
          future: SecureStorage.getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  _nameController.text = user.name!;
                  _emailController.text = user.email!;
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _nameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Name',
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                } else if (!isEmail(value)) {
                                  return 'Email tidak valid';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        bool updateValid = false;

                                        await Utils.dialog(context, () async {
                                          final res = await UserService.update(
                                              id: user.id!,
                                              name: _nameController.text,
                                              email: _emailController.text);
                                          setState(() {
                                            updateValid = res;
                                          });
                                        });

                                        if (updateValid) {
                                          getUser();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Data Berhasil diupdate')));
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (_) => const AlertDialog(
                                              title: Text('Error'),
                                              content: Text(
                                                  'Login tidak valid atau server error'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      'update'.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
