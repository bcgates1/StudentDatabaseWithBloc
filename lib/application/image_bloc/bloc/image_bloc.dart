import 'package:flutter_bloc/flutter_bloc.dart';


part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageState()) {
    on<ImageEvent>((event, emit) {
      return emit(ImageState(path:event.path ));
    });
  }
}
