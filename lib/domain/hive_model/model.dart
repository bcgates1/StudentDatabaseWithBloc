
import 'package:hive_flutter/adapters.dart';
part 'model.g.dart';

@HiveType(typeId: 0)
class StudentModel extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  int age;
  @HiveField(2)
  int phone;
  @HiveField(3)
  String email;
  @HiveField(4)
  String? path;
  StudentModel(
      {required this.name, required this.age, required this.phone, required this.email, this.path});
}
