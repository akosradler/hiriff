import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import './HoizontalChart.dart';

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

  Future productData;

  @override
  initState() {
    super.initState();
    productData = getData(widget.barcode);
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
    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        width: 300.0,
        height: 100.0,
        child: chart,
      ),
    );

    return Scaffold(
        appBar: new AppBar(
          title: new Text('Hiriff'),
          backgroundColor: Colors.orange,
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
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                print('Card tapped.');
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                width: 300,
                                height: 400,
                                child: Column( 
                                  children: [
                                    Text(snapshot.data['name'],  
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
                                    ),
                                    chartWidget
                                  ],
                                )
                              ),
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
            ],
          ),
        ));
  }

  Future getData(String id) async {
    return databaseReference
        .collection("products")
        .document(id)
        .get()
        .then((snapshot) => snapshot.data)
        .then((data) => data);
  }

  // Future getData() {
  //  return databaseReference
  //       .collection("products")
  //       .getDocuments()
  //       .then((snapshot) => {
  //         snapshot.documents.map((document) => document.data)
  //       });

  // }
}