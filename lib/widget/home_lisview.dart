import 'package:auntravel/models/travel_model.dart';
import 'package:auntravel/utility/my_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeListView extends StatefulWidget {
  @override
  _HomeListViewState createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView> {
  // Field
  List<TravelModel> travelModels = List();

  // Method
  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<void> readAllData() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Travel');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.documents;
      for (var snapshot in snapshots) {
        // print('snapshot = ${snapshot.data}');
        TravelModel travelModel = TravelModel.fromJSON(snapshot.data);
        travelModels.add(travelModel);
      }
    });
  }

  Widget showDetail(int index) {
    String string = travelModels[index].detail;
    if (string == null) {
      string = 'Not Detail';
    } else if (string.length > 50) {
      string = string.substring(0, 49);
      string = '$string ...';
    }

    return Text(
      string,
      style:
          TextStyle(color: index % 2 == 0 ? Colors.white : MyStyle().textcolor),
    );
  }

  Widget showName(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          travelModels[index].name,
          style: index % 2 == 0 ? MyStyle().h1WhiteText : MyStyle().h1Text,
        )
      ],
    );
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0, right: 20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          showName(index),
          showDetail(index),
        ],
      ),
    );
  }

  Widget showImage(int index) {
    return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          image: DecorationImage(
            image: NetworkImage(travelModels[index].url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget showListView() {
    return ListView.builder(
      itemCount: travelModels.length,
      itemBuilder: (BuildContext buildContext, int index) {
        return Container(
          decoration: BoxDecoration(
              color: index % 2 == 0 ? MyStyle().barColor : MyStyle().mainColor),
          child: Row(
            children: <Widget>[
              showImage(index),
              showText(index),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Text('This is HomeListView'),
      child: showListView(),
    );
  }
}
