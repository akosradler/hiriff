import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:nice_button/nice_button.dart';
import './HoizontalChart.dart';
import './ComparisonScreen.dart';
import 'package:barcode_scan/barcode_scan.dart';

class DetailsScreen extends StatefulWidget {
  final String barcode;

  DetailsScreen({Key key, this.barcode});

  @override
  _DetailsState createState() => new _DetailsState();
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _DetailsState extends State<DetailsScreen> {
  final databaseReference = Firestore.instance;
  String oldBarcode;

  Future productData;

  @override
  initState() {
    super.initState();
    productData = getData(widget.barcode);
    oldBarcode = widget.barcode;
  }

  @override
  Widget build(BuildContext context) {

    var data = [
      new ClicksPerYear('Fat', (new Random()).nextInt(10) + 1, Colors.purple[200]),
      new ClicksPerYear('Carbohydrate', (new Random()).nextInt(10) + 1, Colors.purple[200]),
      new ClicksPerYear('Protein', (new Random()).nextInt(10) + 1, Colors.purple[200]),
    ];

    var series = [
      new charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: false,
      primaryMeasureAxis:
          new charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );

    var chartWidget = new SizedBox(
      width: 300.0,
      height: 100.0,
      child: chart,
    );

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
               Container(
                 margin: const EdgeInsets.only(top: 30.0),
                 child: 
                 FutureBuilder(
                  future: productData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var price = snapshot.data['price'];
                      var imageId = snapshot.data['imageId'];
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          child: Card(
                            
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                width: 300,
                                height: 600,
                                child: Stack(children: <Widget>[ Column( 
                                  children: [
                                    Text(snapshot.data['name'],  
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Image.asset(
                                      'assets/images/$imageId.png',
                                    ),
                                    ),
                                    chartWidget,
                                    Text('Ingredients', textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                                    // Text(snapshot.data['ingredients'].toString())
                                    Expanded( 
                                      child:  ListView(shrinkWrap: true, children: snapshot.data['ingredients'].map<Widget>((word)=> 
                                      Card(color: Colors.grey[100], child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(word),
                                      ))).toList()
                                      )
                                      
                                      )
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Text('$price €', style: TextStyle(fontSize: 16, color: Colors.grey),),
                                )
                                ]
                                )
                              
                            ),
                          ),
                          
                        );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
               ),
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                color: Colors.purple[300],
                textColor: Colors.white,
                splashColor: Colors.deepOrange,
                onPressed: scan,
                child: const Text('SCAN ANOTHER PRODUCT')
        ),
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

  Future getData(String id) async {
    return databaseReference
        .collection("products")
        .document(id)
        .get()
        .then((snapshot) => snapshot.data)
        .then((data) => data);
  }

  Future scan() async {
      String newBarcode = await BarcodeScanner.scan();
      setState(() => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ComparisonScreen(barcode: oldBarcode, newBarcode: newBarcode)),
                            ));
     
  }
}