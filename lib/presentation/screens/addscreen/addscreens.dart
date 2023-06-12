import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week17studentdatabaseusinghive/application/bloc/student_bloc.dart';
import 'package:week17studentdatabaseusinghive/application/image_bloc/bloc/image_bloc.dart';
import 'package:week17studentdatabaseusinghive/domain/hive_model/model.dart';

class AddScreen extends StatelessWidget {
  AddScreen({super.key});
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController agecontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final GlobalKey<FormState> nameformkey = GlobalKey();
  final GlobalKey<FormState> ageformkey = GlobalKey();
  final GlobalKey<FormState> phoneformkey = GlobalKey();
  final GlobalKey<FormState> emailformkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String? localImagePath;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 350,
              child: Center(
                child: InkWell(
                  onTap: () =>BlocProvider.of<ImageBloc>(context).add(ImageSelector()),
                  child: BlocBuilder<ImageBloc, ImageState>(
                    builder: (context, imagestate) {
                      localImagePath=imagestate.path;
                      return CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 150,
                        backgroundImage: imageselector(imagestate.path),
                      );
                    },
                  ),
                ),
              ),
            ),
            hieghtbox(50),
            textfieldmaker(controller: namecontroller),
            hieghtbox(10),
            textfieldmaker(controller: agecontroller),
            hieghtbox(10),
            textfieldmaker(controller: phonecontroller),
            hieghtbox(10),
            textfieldmaker(controller: emailcontroller),
            hieghtbox(10),
            BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                return ElevatedButton(
                    onPressed: () {
                      bool iscontaining = false;
                      if (nameformkey.currentState!.validate() &&
                          ageformkey.currentState!.validate() &&
                          phoneformkey.currentState!.validate() &&
                          emailformkey.currentState!.validate()) {
                        StudentModel newmodel = StudentModel(
                            name: namecontroller.text,
                            age: int.parse(agecontroller.text),
                            phone: int.parse(phonecontroller.text),
                            email: emailcontroller.text,
                            path: localImagePath);

                        for (StudentModel item in state.studentlist) {
                          if (item.name == newmodel.name &&
                              item.email == newmodel.email &&
                              item.age == newmodel.age &&
                              item.phone == newmodel.phone) {
                            iscontaining = true;
                            break;
                          }
                        }
                        if (!iscontaining) {
                          BlocProvider.of<StudentBloc>(context)
                              .add(StudentAdd(data: newmodel));
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
                    child: const Text('Add'));
              },
            ),
            hieghtbox(20),
          ],
        ),
      ),
    ));
  }

  imageselector(String? path) {
    if (path == null) {
      return const AssetImage('assets/unknown.jpg');
    } else {
      return FileImage(File(path));
    }
  }

 

  Widget hieghtbox(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget textfieldmaker({required TextEditingController controller}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: formkeySelector(controller),
          child: TextFormField(
            validator: (value) {
              return validatorchecking(value, controller);
            },
            controller: controller,
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
                labelText: controller == namecontroller
                    ? 'Name'
                    : controller == agecontroller
                        ? 'Age'
                        : controller == phonecontroller
                            ? 'Phone'
                            : 'Email',
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

  GlobalKey formkeySelector(TextEditingController controller) {
    if (controller == namecontroller) {
      return nameformkey;
    } else if (controller == agecontroller) {
      return ageformkey;
    } else if (controller == phonecontroller) {
      return phoneformkey;
    } else {
      return emailformkey;
    }
  }

  String? validatorchecking(value, TextEditingController controller) {
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
}
