import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week17studentdatabaseusinghive/application/bloc/student_bloc.dart';
import 'package:week17studentdatabaseusinghive/application/image_bloc/bloc/image_bloc.dart';
import 'package:week17studentdatabaseusinghive/domain/hive_model/model.dart';
import 'package:week17studentdatabaseusinghive/presentation/screens/editingscreen/editscreen.dart';

class ProfileScrn extends StatelessWidget {
  final StudentModel profile;
  final int profileindex;
  const ProfileScrn(
      {super.key, required this.profile, required this.profileindex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                          value: BlocProvider.of<StudentBloc>(context)),
                      BlocProvider(
                        create: (context) => ImageBloc(),
                      )
                    ],
                    // value: BlocProvider.of<StudentBloc>(context),
                    child: EditScrn(
                      profile: profile,
                      profileindex: profileindex,
                    ),
                  ),
                ));
              },
              icon: const Icon(
                Icons.edit,
              )),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text('Delete'),
                      content: const Text('Are you sure,\nYou want to delete'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('cancel')),
                        TextButton(
                            onPressed: () {
                              BlocProvider.of<StudentBloc>(context)
                                  .add(StudentRemove(data: profile));
                              Navigator.of(ctx).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'))
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
              ))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: Center(
              child: CircleAvatar(
                radius: 150,
                backgroundImage: imageselector(),
              ),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 70,
              ),
              Text(
                'Name   :   ${profile.name}',
                style: const TextStyle(fontSize: 18),
              ),
              Text('Age      :   ${profile.age}',
                  style: const TextStyle(fontSize: 18)),
              Text('Phone  :   ${profile.phone}',
                  style: const TextStyle(fontSize: 18)),
              Text('Email  :   ${profile.email}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(
                height: 70,
              ),
            ],
          ))
        ],
      ),
    ));
  }

  imageselector() {
    if (profile.path == null) {
      return const AssetImage('assets/unknown.jpg');
    } else {
      return FileImage(File(profile.path!));
    }
  }
}
