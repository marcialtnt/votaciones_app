import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamPageMarcial extends StatefulWidget {
  @override
  State<StreamPageMarcial> createState() => _StreamPageMarcialState();
}

class _StreamPageMarcialState extends State<StreamPageMarcial> {
  CollectionReference partidosReference =
  FirebaseFirestore.instance.collection("partidosPolíticos");

  StreamController<String> myStreamController = StreamController();

  StreamController<int> myIntStreamController = StreamController.broadcast();

  int myCounter = 0;

  Stream<int> counter() async* {
    for (int i = 0; i < 10; i++) {
      yield i;
      await Future.delayed(
        Duration(seconds: 2),
      );
    }
  }

  Future<int> getNumber() async {
    return Future.delayed(Duration(seconds: 3), () {
      return 10;
    });
  }

  @override
  void dispose() {
    myStreamController.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stream Page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myIntStreamController.add(myCounter);
          myCounter++;
        },
        child: Text("Emitir"),
      ),

      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("partidosPolíticos")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('Mira');
              print(snapshot.data!.docs.length);
              print(snapshot.data!.docs.first);
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return ListTile(
                      onTap: () => {actualizar(doc.id, doc["votantes"] + 1)},
                      leading: SizedBox(
                        height: 56,
                        width: 56,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(doc['image']),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      title: Text(
                        doc.id,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      subtitle: Text(doc["representante"]),
                      trailing: Text(
                        doc["votantes"].toString(),
                        style: TextStyle(
                          fontSize: 48,
                        ),
                      ),
                    );
                  });
            } else {
              return Text("No data");
            }
          }),
      // STREAM BUILDER
      // body: StreamBuilder(
      //   stream: counter(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (snapshot.hasData) {
      //       return Center(
      //         child: Text(
      //           snapshot.data.toString(),
      //           style: TextStyle(fontSize: 40),
      //         ),
      //       );
      //     }
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
      //FUTURE BUILDER
      // body: FutureBuilder(
      //   future: getNumber(),
      //   builder: (BuildContext context, AsyncSnapshot snap) {
      //     if (snap.hasData) {
      //       return Center(
      //         child: Text(
      //           snap.data.toString(),
      //           style: TextStyle(fontSize: 40),
      //         ),
      //       );
      //     }
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
    );
  }

  actualizar(String id, int valor) {
    print('id: $id, valor: $valor');
    partidosReference.doc(id).update({"votantes": valor});
  }
}
