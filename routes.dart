//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_login1/profile_screen.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';


class Qrcode extends StatefulWidget {  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QrcodeState();
  }
}

class _QrcodeState extends State<Qrcode> {
  @override
  // ignore: must_call_super
  void initState(){
    //FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser.uid).set({

    //});

  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Profile Barcode'),
            actions:  [IconButton(icon: Icon(Icons.logout),
                onPressed: (){FirebaseAuth.instance.signOut();})],
          ),
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    height: 200,
                    child: SfBarcodeGenerator(
                      value: FirebaseAuth.instance.currentUser.uid,
                      symbology: QRCode(),
                      showValue: true,
                    ),
                  ),
                //  ElevatedButton(onPressed: (){ FirebaseFirestore.instance
                  //    .collection('user').doc(FirebaseAuth.instance.currentUser.uid);}, child: null)

                ],
              )),
        bottomNavigationBar: Container(
          height: 60,
          color: Colors.black12,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      Profile()
                  )
              );
            },
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.qr_code,
                    color: Theme.of(context).accentColor,
                  ),
                  Text('View Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}