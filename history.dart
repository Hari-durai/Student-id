import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget{
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Query query;
  @override
  void initState(){
    query=FirebaseFirestore.instance.collection('history');
    super.initState();
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("History"),),
      body: Container(
        padding: EdgeInsets.only(top: 40),
        child: StreamBuilder<Object>(
            stream: query.snapshots(),
            builder: (context, stream) {
              QuerySnapshot querySnapshot = stream.data;
              if (stream.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator(),);
              else if (stream.hasError) {
                print(query);
              }
              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (ctx, index) =>
                      Card(
                        child: ListTile(title:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${querySnapshot.docs[index]['email']}',
                              style: TextStyle(fontSize: 20),),
                            Text('Name: ${querySnapshot.docs[index]['Username']}',
                              style: TextStyle(fontSize: 20),),
                          ],
                        ),
                          leading: CircleAvatar(radius: 30,backgroundImage: NetworkImage(querySnapshot.docs[index]['imageurl']),),
                          subtitle: Text('Enroll no:${querySnapshot.docs[index]['enrollment_no']}',
                            style: TextStyle(fontSize: 17),),
                          onTap: () {

                          },

                        ),
                      ));
            }),
      ),
    );
  }
}