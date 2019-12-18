import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastchat_0_2/screen/root_page.dart';
import 'package:fastchat_0_2/services/authentication.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  Widget __buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document["names"],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Color(0xffddddff)
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              document["votes"].toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          )
        ],
      ),
      onTap: () {
        Firestore.instance.runTransaction((transaction) async{
          DocumentSnapshot freshSnap =
            await transaction.get(document.reference);
          await transaction.update(freshSnap.reference, {
            "votes": freshSnap["votes"] + 1
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");
          return ListView.builder(
            itemExtent: 80,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                __buildListItem(context, snapshot.data.documents[index]),

          );
        },
      ),
    );
  }
}

