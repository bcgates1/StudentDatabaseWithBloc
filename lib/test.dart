import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'signup_event.dart';
part 'signup_state.dart';
class SignupBloc extends Bloc<SignupEvent, SignupState> { SignupBloc() : super(SignupInitial()) {
on((event, emit) async {
if (event is GetSignup) {
String value = validation(event);
if (value != '') {
emit(SignupValidation(value));
} else {
emit(SignupLoading());
//holds the user for below given time
await Future.delayed(const Duration(seconds: 0), () async { //storing data in SharedPreferences
SharedPreferences prefs = await SharedPreferences.getInstance(); prefs.setString('email', "${event.email}");
prefs.setString('password', "${event.password}"); emit(SignupLoaded());
}).onError((error, stackTrace) {
emit(SignupError(error.toString()));
});
}
}
});
}
}
//validation for text field
String validation(GetSignup data) {
if (data.fullname?.isEmpty == true) {
return 'Please Enter Your Fullname';
}
if (data.email?.isEmpty == true) {
return 'Please Enter Your Email-id';
}
if (data.password?.isEmpty == true) {
return 'Please Enter Your Password';
}
if (data.phoneNumber?.isEmpty == true) {
return 'Please Enter Your Contact Number';
}
return '';
}