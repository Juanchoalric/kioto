import 'dart:async';
import 'validators.dart';
import 'package:rxdart/rxdart.dart';

class Bloc with Validators {

  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  // Add data to the stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get submitValid => 
    Observable.combineLatest2(
      email, 
      password, 
      (e, p) => true
    );

  // Change the data
  Function(String) get changedEmail => _email.sink.add;
  Function(String) get changedPassword => _password.sink.add;
  
  void submit() {
    print('Sending the email: ${_email.value} and the password: ${_password.value}');
  }

  dispose() {
    _email.close();
    _password.close();
  }
}