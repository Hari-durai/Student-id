
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:student_login1/qr_generator.dart';
//import 'package:student_login1/qr_generator.dart';
import 'package:student_login1/routes.dart';

import 'authchange.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(MaterialApp(home: Myapp1() ));
}
bool aut=false;
enum Auth{
  login,
  signup
}
File opicer;
String sendimg;

class Myapp1 extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(body: ChangeNotifierProvider(create: (ctx)=>Autho(),
      child: StreamBuilder(
        stream:FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if (snapshot.hasData && aut==false){
            return Qrcode();
          }
          if (snapshot.hasData && aut==true){
            return MyApp();
          }
          else if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator());
          }
          else{
            return  Home();
          }
        },
      ),
    ) ,);
  }

}

class  Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  Auth auth=Auth.login;
  Map<String,String> data={
    "email":'',
    "password":'',
    "enrollment":'',
    "course":'',
    "name":'',
  };
  final password=TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Future<void> submit() async{
    final valid=_formKey.currentState.validate();
    if(valid){
      _formKey.currentState.save();
    }
    try{
      if(auth==Auth.login){
        await Provider.of<Autho>(context,listen: false).loginemail(data['email'], data['password']);
      }
      if(auth==Auth.signup && aut==false){
        if(sendimg!=null)
          await Provider.of<Autho>(context,listen: false).sigupemail(
              data['email'],
              data['password'],
              data['enrollment'],
              data['course'],
              data['name'],
            sendimg
          );
        else
          showDialog(context: context, builder: (ctx)=>
              AlertDialog(content: Text("Error Occurred"),title: Text("Please upload an image"),actions: [
                TextButton(onPressed:()=>Navigator.of(context).pop(), child:Text("Okay"))
              ],)
          );
      }
      if(auth==Auth.signup && aut==true){
        if(sendimg!=null)
          await Provider.of<Autho>(context,listen: false).sigupemail1(
              data['email'],
              data['password'],
            sendimg
          );
        else
          showDialog(context: context, builder: (ctx)=>
              AlertDialog(content: Text("Error Occurred"),title: Text("Please upload an image"),actions: [
                TextButton(onPressed:()=>Navigator.of(context).pop(), child:Text("Okay"))
              ],)
          );
      }


    }catch(error){
      showDialog(context: context, builder: (ctx)=>
          AlertDialog(content: Text("Error Occurred"),title: Text(error.toString()),actions: [
            TextButton(onPressed:()=>Navigator.of(context).pop(), child:Text("Okay"))
          ],)
      );
    }
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

  void _switch() {
    if (auth == Auth.login) {
      setState(() {
        auth = Auth.signup;
      });
    }
    else {
      setState(() {
        auth = Auth.login;
      });
    }
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Container(width: double.infinity,
      decoration: BoxDecoration(
          gradient:LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink[300],
                Colors.pinkAccent,
                Colors.pink[200]
              ]
          )
      ),
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height:45.0),
          if(auth==Auth.signup)

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

          SizedBox(height:40.0),
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (str){
                  if(str.isEmpty || !str.contains('@')|| !str.contains('.com')){
                    return "Invalid type";
                  }
                  return null;
                },
                onSaved: (str){
                  data['email']=str;
                },
              ),
              SizedBox(height:30.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: password,
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
                validator: (str){
                  if(str.isEmpty ){
                    return "Invalid type";
                  }
                  return null;
                },
                onSaved: (str){
                  data['password']=str;
                },
              ),
              SizedBox(height:30.0),
              if(auth==Auth.signup)
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: 'ReEnter the Password'),
                  validator:auth==Auth.signup ? (str){
                    if(str!=password.text){
                      return "Invalid type";
                    }
                    return null;
                  }:null,

                )
              ,
              if(aut==false && auth==Auth.signup)
                TextFormField(
                  keyboardType: TextInputType.text,
                  //controller: password,
                  decoration: InputDecoration(hintText: 'Name'),
                  //obscureText: true,
                  validator: (str){
                    if(str.isEmpty ){
                      return "Invalid type";
                    }
                    return null;
                  },
                  onSaved: (str){
                    data['name']=str;
                  },
                ),
              if(aut==false && auth==Auth.signup)
                TextFormField(
                  keyboardType: TextInputType.text,
                  //controller: password,
                  decoration: InputDecoration(hintText: 'Enrollment Number'),
                  //obscureText: true,
                  validator: (str){
                    if(str.isEmpty ){
                      return "Invalid type";
                    }
                    return null;
                  },
                  onSaved: (str){
                    data['enrollment']=str;
                  },
                ),
              if(aut==false && auth==Auth.signup)
                TextFormField(
                  keyboardType: TextInputType.text,
                  //controller: password,
                  decoration: InputDecoration(hintText: 'Course'),
                 // obscureText: true,
                  validator: (str){
                    if(str.isEmpty ){
                      return "Invalid type";
                    }
                    return null;
                  },
                  onSaved: (str){
                    data['course']=str;
                  },
                ),

              ElevatedButton(onPressed: submit, child: Text(auth==Auth.login?'Login':'Signup')),
              TextButton(onPressed: _switch,
                  child: Text(auth==Auth.login?'Signup':'Login',
                    style: TextStyle(color: Colors.black),)),
              Row(
                children: [
                  SizedBox(width:120),
                  IconButton(onPressed: (){
                    if(aut==false) {
                      setState(() {
                      aut=true;
                    });
                    } else{
                      setState(() {
                        aut=false;
                      });
                    }

                  }, icon:  Icon(aut==false?Icons.check_box_outline_blank:Icons.check_box,size: 20,)),
                  Text("Admin")
                ],
              ),
              TextButton(
                //style: ButtonStyle(shape: MaterialStateProperty.all<TextDecoration.underline> ),
                child:Text("signin with google",style:TextStyle(decoration: TextDecoration.underline,)),
                onPressed: (){
                  if(data['enrollement']!=null && data['course']!=null)
                    Provider.of<Autho>(context, listen: false).googlelog();
                },

              ),

            ],),
          )
        ],
      ),
    ),);
  }
}