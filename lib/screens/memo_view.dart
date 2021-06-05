import 'package:flutter/material.dart';
import 'package:imemo_mobile/screens/edit.dart';
import 'package:imemo_mobile/colors.dart';

class MemoView extends StatelessWidget {
  final Map<String, dynamic> memoData;
  final int index;
  final Function updateMemoList;
  MemoView({@required this.memoData, @required this.index, @required this.updateMemoList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  //decoration: BoxDecoration(color: Colors.greenAccent),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, size: 25, color: Color(0xff440888)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 52),
                        child: Text(
                          'Memo Details',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff440888)),
                        )
                      ),
                    ],
                  ),
                ),
                // Memo Info
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:  Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          memoData['name'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff323232)),
                        ),
                      ),
                      SizedBox(height: 7),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Date & Time
                            Container(
                              child: Text(
                                timestampToDate(memoData['createAt']),
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  )
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xfffef7e2),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 5),
                        //decoration: BoxDecoration(color: Colors.greenAccent),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 11),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: colors[memoData['category']]['mainColor'],
                              ),
                              child: Text(
                                memoData['category'],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(9)
                                ),
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                  CircleBorder(),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              ),
                              child: Icon(Icons.edit, size: 20, color: Color(0xff323232)),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Edit(
                                    memoData: memoData,
                                    index: index,
                                    updateMemo: updateMemoList
                                  ),
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(color: Colors.black),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 13, left: 20, right: 20),
                        child: Text(
                          memoData['content'],
                          style: TextStyle(fontSize: 20, height: 1.3),
                        ),
                      )
                    ]
                  )
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}

String timestampToDate(timestamp) {
  var rawDate = timestamp.toDate().toString();
  //var date = rawDate.split(" ")[0];
  var time = rawDate.split(".")[0];
  time = time.split(" ")[0] + " | " + time.split(" ")[1];

  return time;
}