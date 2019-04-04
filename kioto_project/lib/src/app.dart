// Import flutter helper library
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Kioto' + '.'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            _counter += 1;
          });
        },
        child: Icon(Icons.add),
      ),
      body: Text('$_counter'),
    ),
  );
  }
}


//Must define a 'buld' method that returns the widgets that *this* widget will show