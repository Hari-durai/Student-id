import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget{
  @override
  Profile1 createState() {
    // TODO: implement createState
    return Profile1();
  }

}
String sendimg;
File opicer;
String name;
String email;
String course;
String enrollment;


class Profile1   extends State<Profile>{

  var em=TextEditingController();

  var nam=TextEditingController();
  var cou=TextEditingController();
  var enrol=TextEditingController();
  @override
  void initState() {
    super.initState();
    return datas();

  }
  void datas(){
    setState(() {

    });
    FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
        setState(() {
          sendimg = value['imageurl'];
        })
    //sendimg = value['imageurl']
      //  name=value['']
    );
    FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
    setState((){
      name = value['Username'];
    })

    );
    FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
    setState((){
      email = value['email'];
    })

    );
    FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
    setState((){
      course = value['course'];
    })

    );
    FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
        setState(() {
          enrollment= value['enrollment_no'];
        })

    );
    setState(() {

    });
}

  void newdata(){
    Map<String,dynamic> data=
    {
      'Username':name,
      'email':email,
     'course':course,
      'imageurl':sendimg,
      'enrollment_no':enrollment
    };
    print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
    print(data);
    FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser.uid).set(data);
  }
  void getimg() async{
    String randomid=randomAlphaNumeric(12);
    final picimges= await ImagePicker().getImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 150);
    setState(() {
      opicer=File(picimges.path);
    });
    final ref=FirebaseStorage.instance.ref().child('Images').child(randomid+'.jpg');
    await ref.putFile(opicer).onComplete;
    final imerr=await ref.getDownloadURL();
    setState(() {
      sendimg=imerr.toString();
    });
    print("imgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg");
    //print(_newcontroller);
    print(sendimg);
    //randomid='';
    //addmessage(true);

  }


  @override
  Widget build(BuildContext context) {
    em.text=email;
    nam.text=name;
    cou.text=course;
    enrol.text=enrollment;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("User Profile"),),
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
                  IconButton(icon: Icon(Icons.camera_alt,color: Colors.white,), onPressed: (){getimg();})
                ],
              ),
            ],
          ),
          SizedBox(height:30.0),
          Column(children: [
            TextFormField(
              keyboardType: TextInputType.text,
              controller: em,
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
              child: ElevatedButton(onPressed: (){
               newdata();
              },child: Text("Save changes"),),)
          ],),

        ],) ,
      )
    );
  }

}