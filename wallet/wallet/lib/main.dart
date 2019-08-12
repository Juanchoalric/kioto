import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData.light(),
  home: App(),
));

