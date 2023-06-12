import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:week17studentdatabaseusinghive/domain/hive_model/model.dart';

List<StudentModel> studentDbAdd(
    {required StudentModel data, required List<StudentModel> studentlist}) {
  final Box<StudentModel> studentdb = Hive.box('studentlist');
  studentlist.add(data);
  studentdb.add(data);
  return studentlist;
}

Future<List<StudentModel>> fetchAllData() async {
  final Box<StudentModel> studentdb = await Hive.openBox('studentlist');
  List<StudentModel> hivelist = [];
  hivelist.addAll(studentdb.values);
  return hivelist;
}

List<StudentModel> studentDbDelete(
    {required StudentModel data, required List<StudentModel> studentlist}) {
  final Box studentdb = Hive.box('studentlist');
  var key = data.key;
  studentdb.delete(key);
  studentlist.remove(data);
  return studentlist;
}

List<StudentModel> studentEdit(
    {required StudentModel data,
    required List<StudentModel> studentlist,
    required int editingindex}) {
  final Box<StudentModel> studentdb = Hive.box('studentlist');
  var key = data.key;
  studentdb.put(key, data);
  studentlist[editingindex] = data;
  return studentlist;
}

List<StudentModel> searchdata(String querry, List<StudentModel> studentlist) {
  List<StudentModel> searchlist=[];
  searchlist = studentlist
      .where((element) =>
          element.name.toLowerCase().contains(querry.trim().toLowerCase()))
      .toList();
  return searchlist;
}

 Future<String?> getimage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
    
  }