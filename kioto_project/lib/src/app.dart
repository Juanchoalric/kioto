// Import flutter helper library
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' show get;

import 'models/image_model.dart';
import 'widgets/image_list.dart';
// Create a class that will be our custom widget
// This class must extend the 'StatelessWidget' base class
class App extends StatefulWidget {
  createState(){
    return AppState();
  }
}

class AppState extends State<App> {
  //Must define a 'buld' method that returns the widgets that *this* widget will show

  int _counter = 0;
  List<ImageModel> images = [];

  void fetchImage() async {
    _counter ++;

    final response = await get('http://jsonplaceholder.typicode.com/photos/$_counter');
    final imageModel = new ImageModel.fromJson(json.decode(response.body));

    setState(() {
      images.add(imageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Kioto' + '.'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchImage,
        child: Icon(Icons.add),
      ),
      body: ImageList(images: images),
    ),
  );
  }
}


//Must define a 'buld' method that returns the widgets that *this* widget will show