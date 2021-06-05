import 'package:flutter/material.dart';
import 'package:imemo_mobile/screens/home.dart';
import 'package:imemo_mobile/widgets/appbar.dart';
import 'package:imemo_mobile/colors.dart';

// Import Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Create extends StatefulWidget {
  @override 
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  var items = ['None', 'Work', 'Study', 'Trip', 'Family', 'Love'];
  String currentCategory = 'None';

  // TextField Controller
  final TextEditingController _memoNameController = TextEditingController();
  final TextEditingController _memoContentController = TextEditingController();

  Future<void> _createMemo(String memoName, String memoContent) async {
    Map<String, dynamic> userData = {};
    // get all memos from firestore
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users.doc(_auth.currentUser.email).get().then((DocumentSnapshot documentSnapshot){
      userData = documentSnapshot.data();
    });
    var allMemos = userData['memos']['all'];
    
    // create new memo
    var newMemo = {
      'name': memoName,
      'category': currentCategory,
      'content': memoContent,
      'createAt': new Timestamp(
        getTimestampSeconds(DateTime.now()),
        getTimestampNanoseconds(DateTime.now()),
      ),
      'pinned': false,
    };
    allMemos.insert(0, newMemo);

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CreateAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Memo Name Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
              //decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Memo Name Input Field
                  Container(
                    child: TextField(
                      controller: _memoNameController,

                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xfff5f5f5),
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Enter memo name',
                        hintStyle: TextStyle(color: Color(0xff808080)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Memo Category
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
              //decoration: BoxDecoration(color: Colors.greenAccent),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: Color(0xff616161)
                      ),
                    ),
                  ),

                  // Dropdown List
                  Container(
                    height: 40,
                    width: 130,

                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: currentCategory,
                        icon: Icon(Icons.expand_more, size: 28, color: Color(0xff616161)),
                        items: items.map((String item) {
                          return DropdownMenuItem(
                            value: item,

                            child: Container(
                              width: 90,
                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 11),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colors[item]['mainColor'],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ),
                          );
                        }).toList(),

                        onChanged: (String value) {
                          setState(() {
                            currentCategory = value;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Memo Content Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30),
              //decoration: BoxDecoration(color: Colors.greenAccent),
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextField(
                      controller: _memoContentController,

                      maxLines: 19,
                      style: TextStyle(fontSize: 19),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xfffef7e2),
                        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Write a memo...',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Create Memo Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              //decoration: BoxDecoration(color: Colors.greenAccent),

              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 13),
                  backgroundColor: Color(0xff440888),
                  primary: Colors.black,
                ),
                child: Text(
                  'Create',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () async {
                  await _createMemo(
                    _memoNameController.text,
                    _memoContentController.text,
                  );
                  
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => new Home(),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int getTimestampSeconds(currentDatetime) {
  final totalMicroseconds = currentDatetime.microsecondsSinceEpoch;
  int seconds = totalMicroseconds ~/ (1000 * 1000);

  return seconds;
}

int getTimestampNanoseconds(currentDatetime) {
  final totalMicroseconds = currentDatetime.microsecondsSinceEpoch;
  int nanoseconds = totalMicroseconds % (1000 * 1000);

  return nanoseconds;
}
