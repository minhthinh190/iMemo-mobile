import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:imemo_mobile/screens/create.dart';
import 'package:imemo_mobile/screens/signin.dart';

import 'package:imemo_mobile/widgets/pinned_list.dart';
import 'package:imemo_mobile/widgets/memo.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  @override 
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Map<String, dynamic> userData = {};

  Future<void> signOut() async {
    final User user = _auth.currentUser;
    await _auth.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.email} signed out.'))
    );
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => SignIn(),
    ));
  }

  Future<void> updateMemo(Map<String, dynamic> memoData, int index) async {
    // get all memos from firestore
    await users.doc(_auth.currentUser.email).get().then((DocumentSnapshot documentSnapshot){
      setState(() {
        userData = documentSnapshot.data();
      });
    });
    // update memo 
    var allMemos = userData['memos']['all'];
    allMemos[index] = memoData;
    // update memo list in firestore
    try {
      users.doc(_auth.currentUser.email).update({
        'memos.all': allMemos,
      });
    } catch(err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  Future<void> pinMemo(Map<String, dynamic> memoData, int index) async {
    if (memoData['pinned'] == false) {  
      // get all memos from firestore
      await users.doc(_auth.currentUser.email).get().then((DocumentSnapshot documentSnapshot){
        setState(() {
          userData = documentSnapshot.data();
        });
      });
      // pin memo
      var allMemos = userData['memos']['all'];
      allMemos[index] = {
        'name': memoData['name'],
        'category': memoData['category'],
        'content': memoData['content'],
        'createAt': memoData['createAt'],
        'pinned': true,
      };
      // update memo list in firestore
      try {
        users.doc(_auth.currentUser.email).update({
          'memos.all': allMemos,
        });
      } catch(err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );
      }
    }
  }

  Future<void> unpinMemo(Map<String, dynamic> memoData) async {
    // get all memos from firestore
    await users.doc(_auth.currentUser.email).get().then((DocumentSnapshot documentSnapshot){
      setState(() {
        userData = documentSnapshot.data();
      });
    });
    // unpin memo
    var allMemos = userData['memos']['all'];
    for (var index = 0; index < allMemos.length; index++) {
      if (allMemos[index]['createAt'] == memoData['createAt']) {
        allMemos[index] = {
          'name': memoData['name'],
          'category': memoData['category'],
          'content': memoData['content'],
          'createAt': memoData['createAt'],
          'pinned': false,
        };
        break;
      }
    }
    // update memo list in firestore
    try {
      users.doc(_auth.currentUser.email).update({
        'memos.all': allMemos,
      });
    } catch(err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  Future<void> deleteMemo(int index) async {
    // get all memos from firestore
    await users.doc(_auth.currentUser.email).get().then((DocumentSnapshot documentSnapshot){
      setState(() {
        userData = documentSnapshot.data();
      });
    });
    // remove the the memo
    var allMemos = userData['memos']['all'];
    allMemos.removeAt(index);
    // update memo list in firestore
    try {
      users.doc(_auth.currentUser.email).update({
        'memos.all': allMemos,
      });
    } catch(err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser.email)
          .snapshots(),
        
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return Text('Something went wrong!');

          if (snapshot.connectionState == ConnectionState.active) {
            Map<String, dynamic> data = snapshot.data.data();

            List memoList = data['memos']['all'];
            List pinnedMemoList = [];
            data['memos']['all'].forEach((element) => {
              if (element['pinned'] == true) pinnedMemoList.insert(0, element)
            });
            pinnedMemoList = new List.from(pinnedMemoList.reversed);

            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffc5cae9).withOpacity(0.5),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Dashboard Title
                      Container(
                        padding: EdgeInsets.only(left: 30, right: 10, top: 35, bottom: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Dashboard',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff440888)),
                            ),
                            Container(
                              //decoration: BoxDecoration(color: Colors.greenAccent),
                              child: PopupMenuButton(
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Icon(Icons.logout, color: Color(0xff440888)),
                                          Text('Sign out', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff532d84))),
                                        ],
                                      ),
                                    ),
                                    value: 'Sign out',
                                  ),
                                ],
                                onSelected: (value) { signOut(); },
                                icon: Icon(Icons.segment, color: Color(0xff440888)),
                              ),
                            ),
                          ]
                        ),
                      ),
                      // Pinned Memo Container
                      Container(
                        width: double.infinity,
                        height: 260,
                        padding: EdgeInsets.only(bottom: 20),
                        //decoration: BoxDecoration(color: Colors.greenAccent),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Section name
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                'Pinned' + ' (' + pinnedMemoList.length.toString() + ')',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff616161)),
                              )
                            ),

                            // Pinned Memo Card List
                            pinnedList(
                              pinnedMemos: pinnedMemoList,
                              unpinMemo: unpinMemo,
                              updateMemoList: updateMemo,
                            ),
                          ],
                        ),
                      ),
                        
                      // All Memos List Container
                      Container(
                        width: double.infinity,
                        
                        // All Memos List
                        child: Container(
                          padding: EdgeInsets.only(top: 40, bottom: 80, left: 30, right: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Section name
                              Container(
                                margin: EdgeInsets.only(bottom: 25),
                                child: Text(
                                  'All' + ' (' + memoList.length.toString() + ')',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff616161)),
                                )
                              ),
                              if (memoList.length == 0) 
                                Text(
                                  "You don't have any memo.",
                                  style: TextStyle(fontSize: 20, color: Color(0xff9e9e9e)),
                                )
                              else for (var i = 0; i < memoList.length; i++) 
                                Memo(
                                  memoData: memoList[i], 
                                  index: i, 
                                  updateMemoList: updateMemo,
                                  pinMemo: pinMemo,
                                  deleteMemo: deleteMemo,
                                )
                            ],
                          )
                        ),
                      ),
                    ]
                  )
                )
              )
            );
          }
          
          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff323232)),
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff440888),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => Create(),
          ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
