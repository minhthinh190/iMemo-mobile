import 'package:flutter/material.dart';
import 'package:imemo_mobile/screens/memo_view.dart';
import 'package:imemo_mobile/colors.dart';

class Memo extends StatelessWidget {
  final Map<String, dynamic> memoData;
  final int index;
  final Function updateMemoList;
  final Function pinMemo;
  final Function deleteMemo;

  Memo({
    Key key, 
    @required this.memoData, 
    @required this.index,
    @required this.updateMemoList,
    @required this.pinMemo,
    @required this.deleteMemo,
  }) : super(key: key);

  String shortenMemoName(memoName) {
    var shortMemoName;
    memoName.length > 30 ? 
      shortMemoName = memoName.substring(0, 30) + '...'
      :
      shortMemoName = memoName;
  
    return shortMemoName;
  }

  @override 
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => MemoView(
            memoData: memoData, 
            index: index,
            updateMemoList: updateMemoList,
          ),
        ));
      },

      child: Container(
        width: double.infinity,
        height: 122,
        margin: EdgeInsets.only(bottom: 22),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colors[memoData['category']]['background'],
          boxShadow: [
            BoxShadow(
              color: Color(0xff283593).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 14,
              offset: Offset(0, 6), // changes position of shadow
            ),
          ], 
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Memo Card Name & Info
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    shortenMemoName(memoData['name']),
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: colors[memoData['category']]['mainColor'],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    timestampToDate(memoData['createAt']),
                    style: TextStyle(fontSize: 17, color: Color(0xff808080)),
                  ),
                ],
              ),
            ),

            // Memo Card Button
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Pin Button
                  Container(
                    width: 45,
                    height: 35,
                    margin: EdgeInsets.only(left: 5),
                    //decoration: BoxDecoration(color: Colors.amberAccent),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: colors[memoData['category']]['buttonColor'],
                        primary: colors[memoData['category']]['mainColor'],
                      ),
                      child: Icon(Icons.push_pin, size: 20),
                      onPressed: () async {
                        await pinMemo(memoData, index);
                      },
                    ),
                  ),

                  // Delete Button
                  Container(
                    width: 45,
                    height: 35,
                    margin: EdgeInsets.only(left: 5),
                    //decoration: BoxDecoration(color: Colors.amberAccent),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: colors[memoData['category']]['buttonColor'],
                        primary: colors[memoData['category']]['mainColor'],
                      ),
                      child: Icon(Icons.delete, size: 20),
                      onPressed: () async {
                        await deleteMemo(index);
                      },
                    ),
                  )
                ],
              ),
            )
          ]
        )
      ),
    );
  }
}

String timestampToDate(timestamp) {
  var rawDate = timestamp.toDate().toString();
  var date = rawDate.split(" ")[0];

  return date;
}