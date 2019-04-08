import 'package:flutter/material.dart';
import '../blocs/bloc.dart';
import '../blocs/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          emailTextField(bloc),
          passwordField(bloc),
          Container(
            margin: EdgeInsets.only(top: 20.0),
          ),
          submitButton(bloc),
        ],
      ),
    );
  }

  Widget emailTextField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (BuildContext context, snapshot) {
        return TextField(
          onChanged: bloc.changedEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              errorText: snapshot.error,
              hintText: "you@example.com",
              labelText: 'Email Address'),
        );
      },
    );
  }

  Widget passwordField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (BuildContext context, snapshot) {
        return TextField(
          onChanged: bloc.changedPassword,
          obscureText: true,
          decoration: InputDecoration(
              errorText: snapshot.error,
              hintText: "Password",
              labelText: 'Password'),
        );
      },
    );
  }

  Widget submitButton(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (BuildContext context, snapshot) {
        return RaisedButton(
          onPressed: snapshot.hasData  ? bloc.submit : null,
          color: Colors.blueAccent,
          textColor: Colors.white,
          child: Text("Login"),
        );
      },
    );
  }
}
