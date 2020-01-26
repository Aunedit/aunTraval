import 'dart:async';

import 'package:auntravel/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddTravel extends StatefulWidget {
  @override
  _AddTravelState createState() => _AddTravelState();
}

class _AddTravelState extends State<AddTravel> {
  // field

  double lat, lng;
  LatLng latLng;

  // Method

  @override
  void initState(){
    super.initState();
    findLocation();

  }


  Future<void> findLocation()async{

    Duration duration = Duration(seconds: 10);
    await Timer(duration, (){
      setState(() {
        lat = 13.745846;
        lng = 100.506690;
      });
    });

  }

  void setUpLatLng(){}


  Widget nameForm() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'NameTravel',
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.photo, color: Colors.white),
        ),
      ),
    );
  }

  Widget detailForm() {
    return Container(
      // height: 50.0,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Detail Travel',
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(
            Icons.details,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget showPic() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Image.asset('images/pic.png'),
    );
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(Icons.add_a_photo),
      onPressed: () {},
    );
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(Icons.add_photo_alternate),
      onPressed: () {},
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showMap() {
    if (lat != null) {
      latLng = LatLng(lat, lng);
      CameraPosition cameraPosition =
          CameraPosition(target: latLng, zoom: 16.0);

      return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController googleMapController){},
      );
    }
  }

  Widget showContent() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: lat == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : showMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().barColor,
        title: Text('Add New Travel'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          showPic(),
          showButton(),
          nameForm(),
          SizedBox(
            height: 8.0,
          ),
          detailForm(),
          showContent(),
        ],
      ),
    );
  }
}
