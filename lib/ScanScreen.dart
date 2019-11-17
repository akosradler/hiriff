import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './DetailsScreen.dart';
import './PieChart.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Hiriff'),
          backgroundColor: Colors.purple[200],
          centerTitle: true,
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10),child: Text('')),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Image.asset(
                'assets/images/logo.png',
                height: 150,
              ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text('Track your nutritional intake', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
                ),
              ),
              Container(
                width: 200,
                height: 200,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: DonutAutoLabelChart.withSampleData()
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.purple[300],
                    textColor: Colors.white,
                    splashColor: Colors.deepOrange,
                    onPressed: scan,
                    child: const Text('SCAN  PRODUCT')
                ),
              )
              
              ,
            ],
          ),
        ),
        bottomNavigationBar:BottomNavigationBar(
        type: BottomNavigationBarType.fixed ,
        fixedColor: Colors.purple[100],
        backgroundColor: Colors.purple[100],
        items: [
        BottomNavigationBarItem(
        icon: Icon(Icons.accessibility_new,color: Color.fromARGB(255, 0, 0, 0)),
        title: new Text('')
        ),
        BottomNavigationBarItem(
        icon: Icon(Icons.add_a_photo,color: Color.fromARGB(255, 0, 0, 0)),
        title: new Text('')
        ),
        BottomNavigationBarItem(
        icon: Icon(Icons.adjust,color: Color.fromARGB(255, 0, 0, 0)),
        title: new Text('')
        ),
        BottomNavigationBarItem(
        icon: Icon(Icons.help,color: Color.fromARGB(255, 0, 0, 0)),
        title: new Text('')
        )
        ],


        )
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailsScreen(barcode: barcode)),
                            ));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}