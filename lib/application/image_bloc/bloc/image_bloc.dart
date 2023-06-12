import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week17studentdatabaseusinghive/infrastructure/functions.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageState()) {
    on<ImageSelector>((event, emit) async {
      String? path = await getimage();
      return emit(ImageState(path: path ?? state.path));
    });
    on<ImageEditor>((event, emit) {
      return emit(ImageState(path: event.imgpath));
    });
  }
}
