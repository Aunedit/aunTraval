import 'dart:io';

import 'package:auntravel/utility/my_style.dart';
import 'package:auntravel/widget/home_lisview.dart';
import 'package:auntravel/widget/information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Travel extends StatefulWidget {
  @override
  _TravelState createState() => _TravelState();
}

class _TravelState extends State<Travel> {
  // Field

  String name = '', email = '', uid, url;
  Widget currentWiddet = HomeListView();

  // Method
  @override
  void initState() {
    super.initState();
    findUID();
  }

  Future<void> findUID() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    uid = firebaseUser.uid;
    setState(() {
      email = firebaseUser.email;
    });
    print('uid = $uid, email = $email');
    findName();
  }

  Future<void> findName() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Travel');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> documentSnapshots = response.documents;
      for (var snapshot in documentSnapshots) {
        // String name = snapshot.data['Name'];
        // print('name = $name');

        String myUID = snapshot.data['Uid'];
        if (myUID == uid) {
          setState(() {
            name = snapshot.data['Name'];
            url = snapshot.data['Url'];
          });
          print('name = $name');
        }
      }
    });
  }

  Widget showAvatar() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: url == null ? Image.asset('images/logo.png') : showAvatarFromFirebase(),
    );
  }

  Widget showAvatarFromFirebase(){
    return CircleAvatar(backgroundImage: NetworkImage(url),);
  }

  Widget headDrawer() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: showAvatar(),
      accountName: Text(
        '$name',
        style: MyStyle().h1WhiteText,
      ),
      accountEmail: Text('$email'),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          headDrawer(),
          homeListMenu(),
          informationMenu(),
          signOutMenu(),
        ],
      ),
    );
  }

  Widget homeListMenu() {
    return ListTile(
      leading: Icon(Icons.filter_1),
      title: Text('Home ListView'),
      subtitle: Text('Description for Header'),
      onTap: () {
        setState(() {
          currentWiddet = HomeListView();
        });
        currentWiddet = HomeListView();
        Navigator.of(context).pop();
      },
    );
  }

  Widget informationMenu() {
    return ListTile(
      leading: Icon(Icons.filter_1),
      title: Text('information'),
      subtitle: Text('Description for Header'),
      onTap: () {
        setState(() {
          currentWiddet = Information();
        });
        currentWiddet = Information();
        Navigator.of(context).pop();
      },
    );
  }

  Widget signOutMenu() {
    Color color = Colors.red;
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        color: color,
      ),
      title: Text(
        'SignOut',
        style: TextStyle(color: color),
      ),
      subtitle: Text('Description for Header'),
      onTap: () {
        processSignOut();
      },
    );
  }

  Future<void> processSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      exit(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().mainColor,
        title: Text('Travel'),
      ),
      drawer: showDrawer(),
      body: currentWiddet,
    );
  }
}
