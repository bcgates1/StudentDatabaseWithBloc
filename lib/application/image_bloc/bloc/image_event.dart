part of 'image_bloc.dart';

class ImageEvent {}

class ImageSelector extends ImageEvent {}

class ImageEditor extends ImageEvent {
  String? imgpath;
  ImageEditor({required this.imgpath});
}
