import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auntravel/utility/my_style.dart';
import 'package:auntravel/utility/normal_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AddTravel extends StatefulWidget {
  @override
  _AddTravelState createState() => _AddTravelState();
}

class _AddTravelState extends State<AddTravel> {
  // field

  double lat, lng;
  LatLng latLng;
  File file;
  String name, detail, url;

  // Method

  @override
  void initState() {
    super.initState();
    findLocation();
  }

  Future<LocationData> findLocationData() async {
    var location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<void> findLocation() async {
    LocationData locationData = await findLocationData();

    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });

    // Duration duration = Duration(seconds: 10);
    // await Timer(duration, () {
    //   setState(() {
    //     lat = 13.745846;
    //     lng = 100.506690;
    //   });
    // });
  }

  void setUpLatLng() {}

  Widget nameForm() {
    return Container(
      // height: 50.0,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        onChanged: (String string) {
          name = string.trim();
        },
        maxLines: 2,
        keyboardType: TextInputType.multiline,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Name',
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
        onChanged: (value) {
          detail = value.trim();
        },
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Detail',
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
      // child: Image.asset('images/pic.png'),
      child: file == null ? Image.asset('images/pic.png') : Image.file(file),
    );
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(30),
        infoWindow: InfoWindow(
          title: 'You Location',
          snippet: 'lat = $lat, lng = $lng',
        ),
        position: latLng,
        markerId: MarkerId('myPosition'),
      ),
    ].toSet();
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(Icons.add_a_photo),
      onPressed: () {
        cameraOrGallery(ImageSource.camera);
      },
    );
  }

  Future<void> cameraOrGallery(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(Icons.add_photo_alternate),
      onPressed: () {
        cameraOrGallery(ImageSource.gallery);
      },
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
        markers: myMarker(),
        mapType: MapType.satellite,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController googleMapController) {},
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

  Widget saveButton() {
    return RaisedButton(
      color: MyStyle().barColor,
      child: Text(
        'Save and Upload',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        if (file == null) {
          normalDialog(
              context, 'Non Choose Image', 'Please Click on Camera or Gallery');
        } else if (name == null ||
            name.isEmpty ||
            detail == null ||
            detail.isEmpty) {
          normalDialog(context, 'Have Space', 'Pleae Fill Every Blank');
        } else {
          confirmDialog();
        }
      },
    );
  }

  Widget showName() {
    return Text('Name = $name');
  }

  Widget showDetail() {
    return Text('Detail = $detail');
  }

  Widget showImage() {
    return Container(
      height: 200.0,
      child: Image.file(file),
    );
  }

  Widget showLocation() {
    return Text(
      'Lat = $lat, Lng = $lng',
      style: TextStyle(fontSize: 12.0),
    );
  }

  Widget showConfirmContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showName(),
        showDetail(),
        showImage(),
        showLocation(),
      ],
    );
  }

  Widget cancelButton() {
    return FlatButton(
      child: Text(
        'Cancel',
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget confirmButton() {
    return FlatButton(
      child: Text(
        'Confirm',
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        uploadPicture();
      },
    );
  }

  Future<void> uploadPicture() async {
    var now = new DateTime.now();

    Random random = Random();
    int i = random.nextInt(10000);
    String string = '$now/Picture.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Onepiece/$string');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('url = $url');
    inserValueToFirestore();
  }

  Future<void> inserValueToFirestore() async {
    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Detail'] = detail;
    map['Url'] = url;
    map['Lat'] = lat;
    map['Lng'] = lng;

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Travel');
    await collectionReference.document().setData(map).then((response) {
      Navigator.of(context).pop();
    });
  }

  Future<void> confirmDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please Confirm Data'),
            content: showConfirmContent(),
            actions: <Widget>[cancelButton(), confirmButton()],
          );
        });
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
          SizedBox(
            height: 8.0,
          ),
          showContent(),
          SizedBox(
            height: 8.0,
          ),
          saveButton(),
        ],
      ),
    );
  }
}
