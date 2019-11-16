import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class DetailsScreen extends StatefulWidget {
  final String barcode;

  DetailsScreen({Key key, this.barcode});

  @override
  _DetailsState createState() => new _DetailsState();
}

class _DetailsState extends State<DetailsScreen> {
  final databaseReference = Firestore.instance;
  Future productData;

  @override
  initState() {
    super.initState();
    productData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Hiriff'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: FutureBuilder(
                  future: productData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.toString());
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              )
              ,
            ],
          ),
        ));
  }

  Future getData() {
   return databaseReference
        .collection("products")
        .getDocuments()
        .then((snapshot) => {
          snapshot.documents.map((document) => document.data)
        });

  }
}