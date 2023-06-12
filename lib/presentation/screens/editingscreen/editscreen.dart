import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week17studentdatabaseusinghive/application/bloc/student_bloc.dart';
import 'package:week17studentdatabaseusinghive/application/image_bloc/bloc/image_bloc.dart';
import 'package:week17studentdatabaseusinghive/domain/hive_model/model.dart';

class EditScrn extends StatelessWidget {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController agecontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final GlobalKey<FormState> nameformkey = GlobalKey();
  final GlobalKey<FormState> ageformkey = GlobalKey();
  final GlobalKey<FormState> phoneformkey = GlobalKey();
  final GlobalKey<FormState> emailformkey = GlobalKey();
  final StudentModel profile;
  final int profileindex;
  EditScrn({super.key, required this.profile, required this.profileindex});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ImageBloc>(context).add(ImageEditor(imgpath: profile.path));
    bool iscontaining = false;
    String? imagepath;

    namecontroller.text = profile.name;
    agecontroller.text = profile.age.toString();
    phonecontroller.text = profile.phone.toString();
    emailcontroller.text = profile.email.toString();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          return ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<ImageBloc>(context).add(ImageSelector());
                  },
                  child: BlocBuilder<ImageBloc, ImageState>(
                    builder: (context, state) {
                      imagepath = state.path;
                      return CircleAvatar(
                        radius: 150,
                        backgroundImage: imageselector(state.path),
                      );
                    },
                  ),
                ),
              ),
              heightbox(30),
              textfield('Name', nameformkey, namecontroller),
              heightbox(20),
              textfield('Age', ageformkey, agecontroller),
              heightbox(20),
              textfield('Phone', phoneformkey, phonecontroller),
              heightbox(20),
              textfield('Email', emailformkey, emailcontroller),
              heightbox(30),
              SizedBox(
                height: 50,
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (nameformkey.currentState!.validate() &&
                            ageformkey.currentState!.validate() &&
                            phoneformkey.currentState!.validate() &&
                            emailformkey.currentState!.validate()) {
                          List<StudentModel> templist =
                              templistvalueassigning(state.studentlist);
                          iscontaining = updatechecking(templist, imagepath);
                          if (!iscontaining) {
                            BlocProvider.of<StudentBloc>(context).add(
                                StudentEdit(
                                    data: profile, editingindex: profileindex));
                            Navigator.of(context).pop();
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: const Text('Item already exist...'),
                                  title: const Text('Oops...'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          iscontaining = false;
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'))
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      child: const Text('Save')),
                ),
              ),
              heightbox(30),
            ],
          );
        },
      ),
    ));
  }

  bool updatechecking(List<StudentModel> templist, String? imagepath) {
    bool iscontaining = false;
    if (nameformkey.currentState!.validate() &&
        ageformkey.currentState!.validate() &&
        phoneformkey.currentState!.validate() &&
        emailformkey.currentState!.validate()) {
      profile.name = namecontroller.text;
      profile.age = int.parse(agecontroller.text);
      profile.phone = int.parse(phonecontroller.text);
      profile.email = emailcontroller.text;
      profile.path = imagepath;
    }
    if (templist.isNotEmpty) {
      for (StudentModel item in templist) {
        if (item.name == profile.name &&
            item.email == profile.email &&
            item.age == profile.age &&
            item.phone == profile.phone) {
          iscontaining = true;
          break;
        }
      }
    }
    return iscontaining;
  }

  List<StudentModel> templistvalueassigning(List<StudentModel> studentlist) {
    List<StudentModel> templist = [];
    for (StudentModel item in studentlist) {
      if (item == profile) {
        continue;
      } else {
        templist.add(item);
      }
    }
    return templist;
  }

  Widget heightbox(double height) {
    return SizedBox(height: height);
  }

  Widget textfield(String label, GlobalKey<FormState> key,
      TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: key,
          child: TextFormField(
            controller: controller,
            validator: (value) {
              return validatorchecking(controller);
            },
            maxLength: lengthselector(controller: controller),
            keyboardType:
                controller == agecontroller || controller == phonecontroller
                    ? TextInputType.number
                    : TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 3,
                    )),
                labelText: label,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 3,
                    ))),
          ),
        ));
  }

  int? lengthselector({required TextEditingController controller}) {
    if (controller == agecontroller) {
      return 2;
    } else if (controller == phonecontroller) {
      return 10;
    } else {
      return null;
    }
  }

  String? validatorchecking(TextEditingController controller) {
    if (controller == namecontroller) {
      if (namecontroller.text.isEmpty) {
        return 'Name is required';
      }
    } else if (controller == agecontroller) {
      if (agecontroller.text.isEmpty) {
        return 'Age is required';
      } else if (int.tryParse(agecontroller.text) == null) {
        return 'Age should be number';
      }
    } else if (controller == phonecontroller) {
      if (phonecontroller.text.isEmpty) {
        return 'Phone is required';
      } else if (int.tryParse(phonecontroller.text) == null) {
        return 'Age should be number';
      } else if (phonecontroller.text.length != 10) {
        return 'Must contain 10 digit';
      }
    } else if (controller == emailcontroller) {
      if (emailcontroller.text.isEmpty) {
        return 'Email is required';
      }
    }

    return null;
  }

  ImageProvider imageselector(String? path) {
    if (path == null) {
      return const AssetImage('assets/unknown.jpg');
    } else {
      return FileImage(File(path));
    }
  }
}
