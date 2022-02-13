import 'dart:async';


// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:student_login1/history.dart';
//import 'package:loginpage1/routes.dart';

//void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
String sendimg;

String name;
String email;
String course;
String enrollment;
String a;


class _MyAppState extends State<MyApp> {
  String _scanBarcode = '';
  Query query;

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState()  {
   setState(() {

   });
   if(_scanBarcode!='' && _scanBarcode!='-1'){
   FirebaseFirestore.instance.collection('user')
       .doc(_scanBarcode).get().then((value) =>
       setState((){
         sendimg = value['imageurl'];
       })

     //  name=value['']
   );
   FirebaseFirestore.instance.collection('user')
       .doc(_scanBarcode).get().then((value) =>
       setState((){
         name = value['Username'];
       })

   );
   FirebaseFirestore.instance.collection('user')
       .doc(_scanBarcode).get().then((value) =>
       setState((){
         email = value['email'];
       })

   );
   FirebaseFirestore.instance.collection('user')
       .doc(_scanBarcode).get().then((value) =>
       setState((){
         course = value['course'];
       })

   );
   FirebaseFirestore.instance.collection('user')
       .doc(_scanBarcode).get().then((value) =>
       setState(() {
         enrollment = value['enrollment_no'];
       })

   );
    }
      if(name!=null){
        setState(() {
          a=name;
        });
      }

    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      query=FirebaseFirestore.instance.collection('user');

    });
    if(_scanBarcode!='' && _scanBarcode!='-1') {
      FirebaseFirestore.instance.collection('user')
          .doc(_scanBarcode).get().then((value) =>
          setState((){
            sendimg = value['imageurl'];
          })

        //  name=value['']
      );
      FirebaseFirestore.instance.collection('user')
          .doc(_scanBarcode).get().then((value) =>
          setState((){
            name = value['Username'];
          })

      );
      FirebaseFirestore.instance.collection('user')
          .doc(_scanBarcode).get().then((value) =>
          setState((){
            email = value['email'];
          })

      );
      FirebaseFirestore.instance.collection('user')
          .doc(_scanBarcode).get().then((value) =>
          setState((){
            course = value['course'];
          })

      );
      FirebaseFirestore.instance.collection('user')
          .doc(_scanBarcode).get().then((value) =>
          setState(() {
            enrollment = value['enrollment_no'];
          })

      );
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }


  @override
  Widget build(BuildContext context) {


    return MaterialApp(
        home:((_scanBarcode=='' || _scanBarcode=='-1' ) && a==null) ? Scaffold(
          extendBody: true,//for bottom nagivation
            appBar: AppBar(title: const Text('Welcome'),
                backgroundColor: Colors.purpleAccent,
                centerTitle: true,leading: IconButton(icon: Icon(Icons.qr_code_scanner),
                  iconSize: 50,onPressed: (){scanQR();},),
               actions: [IconButton(icon: Icon(Icons.logout),
                onPressed: (){//FirebaseAuth.instance.signOut();
                 setState(() async{
                   await FirebaseAuth.instance.signOut();
                 });

               })]
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: Colors.blue,
              buttonBackgroundColor: Colors.pinkAccent,
              backgroundColor: Colors.transparent,
             // height: 70,
              key: _bottomNavigationKey,
              items: [Icon(Icons.home_filled, size: 30,),
                Icon(Icons.camera,size: 35, ),
                Icon(Icons.help,size: 30, ),
                Icon(Icons.history,size: 30,)],
              onTap: (index){
                if(index==1){
                  //index=2;
                  return scanQR();
                  //index=2;
                }

                if(index==3) {
                  return  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          History()
                      )
                  );
                }
              },
             // backgroundColor: Colors.blueAccent,
            //  animationCurve: Curves.easeInOut,
              //animationDuration: Duration(milliseconds: 600),
            ),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  color: Colors.white,
                  height: double.infinity,
                  width: double.infinity,

                  //alignment: Alignment.center,
                  child:Center(child: Text("Scan QrCode"))
                   );
            })):

       GetFirebase());
  }

  // ignore: non_constant_identifier_names
  GetFirebase() {
    setState(() {

    });
    FirebaseFirestore.instance.collection('user')
        .doc(_scanBarcode).get().then((value) =>
    setState((){
      sendimg = value['imageurl'];
    })

      //  name=value['']
    );
    FirebaseFirestore.instance.collection('user')
        .doc(_scanBarcode).get().then((value) =>
    setState((){
      name = value['Username'];
    })

    );
    FirebaseFirestore.instance.collection('user')
        .doc(_scanBarcode).get().then((value) =>
    setState((){
      email = value['email'];
    })

    );
    FirebaseFirestore.instance.collection('user')
        .doc(_scanBarcode).get().then((value) =>
    setState((){
      course = value['course'];
    })

    );
    FirebaseFirestore.instance.collection('user')
        .doc(_scanBarcode).get().then((value) =>
        setState(() {
          enrollment = value['enrollment_no'];
        })

    );
    setState(() {

    });

    var em=TextEditingController();

    var nam=TextEditingController();
    var cou=TextEditingController();
    var enrol=TextEditingController();
    em.text=email;
    nam.text=name;
    cou.text=course;
    enrol.text=enrollment;
    return Scaffold(appBar: AppBar(title: Text("Student Detail"),
        leading: IconButton(icon:Icon(Icons.arrow_back_ios),onPressed: (){setState(() {
          a=null;
          _scanBarcode='';
        });},),
        centerTitle: true,
        backgroundColor: Colors.brown,
        actions: [IconButton(icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            })
        ]),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.blue,
          buttonBackgroundColor: Colors.pinkAccent,
          backgroundColor: Colors.transparent,
          // height: 70,
          key: _bottomNavigationKey,
          items: [Icon(Icons.home_filled, size: 30,),
            Icon(Icons.camera,size: 35, ),
            Icon(Icons.help,size: 30, ),
            Icon(Icons.history,size: 30,)],
          onTap: (index){
            if(index==1){
              return scanQR();
            }


            if(index==3) {
              return Navigator.push(
                  context,
                  MaterialPageRoute(builder
                      : (context) => History()));
            }
          },
          // backgroundColor: Colors.blueAccent,
          //  animationCurve: Curves.easeInOut,
          //animationDuration: Duration(milliseconds: 600),
        ),
        body:Container(
          margin: EdgeInsets.all(20),
          width: double.infinity,
          child:ListView(children: [
            SizedBox(height:45.0),
            Row(
              children: [
                SizedBox(width: 120,),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black26,
                      backgroundImage:sendimg!=null? NetworkImage(sendimg):null,

                    ),

                  ],
                ),
              ],
            ),
            SizedBox(height:30.0),
            Column(children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: em,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Email'),
                // obscureText: true,
                validator: (str){
                  if(str.isEmpty ){
                    return "Invalid type";
                  }
                  return null;
                },
                onSaved: (str){
                  //name=str;
                },
              ),
              SizedBox(height:30.0),
              TextFormField(
                keyboardType: TextInputType.text,
                readOnly: true,
                controller: nam,
                decoration: InputDecoration(labelText: 'Username',),
                //obscureText: true,
                validator: (str){
                  if(str.isEmpty ){
                    return "Invalid type";
                  }
                  return null;
                },
                onChanged: (str){
                  name=str;
                },
              ),
              SizedBox(height:30.0),
              TextFormField(
                keyboardType: TextInputType.text,
                readOnly: true,
                controller: enrol,
                decoration: InputDecoration(labelText: 'Enrollment number'),
                //obscureText: true,
                validator: (str){
                  if(str.isEmpty ){
                    return "Invalid type";
                  }
                  return null;
                },
                onChanged: (str){
                  setState(() {
                    enrollment=str;
                  });

                },
              ),
              SizedBox(height:30.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: cou,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Course'),
                //obscureText: true,
                validator: (str){
                  if(str.isEmpty ){
                    return "Invalid type";
                  }
                  return null;
                },
                onChanged: (str){
                  course=str;
                },
              ),
              SizedBox(height: 30,),
              SizedBox(
                //height: 100,
                width: 300,
                child: ElevatedButton(onPressed: () {
                  setState(() async{
                    a=null;
                    await FirebaseFirestore.instance.collection('history').doc(_scanBarcode).set({
                      'email':em.text,
                      'Username':name,
                      'imageurl':sendimg,
                      'enrollment_no':enrollment,
                      'course':course,
                      'Date':DateTime.now()

                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            History()
                        )
                    );
                  });
                 // newdata();
                },child: Text("Confirm"),),)
            ],),

          ],) ,
        )
    ); ////chats/iqQmYmGutZmxOlkFDpV4/message


  }
}

