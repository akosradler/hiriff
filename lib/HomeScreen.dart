import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './ScanScreen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[200],
          centerTitle: true,
          title: Text('Hiriff'),
        ),
        body: Center(
            child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: RaisedButton(
                          color: Colors.orange,
                          textColor: Colors.white,
                          splashColor: Colors.deepOrange,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ScanScreen()),
                            );
                          },
                          child: const Text('SCAN BARCODE')
                      ),
                    ),
                   
                ],
              )
          ),
          bottomNavigationBar:BottomNavigationBar(
            type: BottomNavigationBarType.shifting ,
            items: [
            BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('')
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('')
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('')
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('')
            )
            ],
        )
    );
  }
}