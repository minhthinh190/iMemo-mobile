import 'package:flutter/material.dart';
import 'package:imemo_mobile/screens/memo_view.dart';
import 'package:imemo_mobile/colors.dart';

Widget pinnedList({List pinnedMemos, Function unpinMemo, Function updateMemoList, context}) {
  return Container(
    height: 210,
    //padding: EdgeInsets.symmetric(vertical: 20),
    //decoration: BoxDecoration(color: Colors.redAccent),

    child: ListView.builder(
      itemCount: pinnedMemos.length,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 20),

      itemBuilder: (context, index) {
        // Pinned Memo Card
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => MemoView(
                memoData: pinnedMemos[index], 
                index: index,
                updateMemoList: updateMemoList,
              ),
            ));
          },
          child: Container(
            width: 200,
            margin: index == 0 ? 
              EdgeInsets.only(left: 30, right: 22) : EdgeInsets.only(right: 22),
            padding: EdgeInsets.only(top: 5, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 15,
                  offset: Offset(0, 6), // changes position of shadow
                ),
              ], 
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(0),
                  //decoration: BoxDecoration(color: Colors.greenAccent),
                  
                  // Pinned Memo Card Buttons
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Category Info Flash
                      Container(
                        width: 45,
                        height: 5,
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: colors[pinnedMemos[index]['category']]['mainColor'],
                        ),
                      ),

                      // Un-Pinned Button
                      Container(
                        width: 50,
                        height: 34,
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        //decoration: BoxDecoration(color: Colors.redAccent),
                        
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: CircleBorder(),
                            //backgroundColor: Color(0xffdcdcdc),
                            primary: Color(0xff808080),
                          ),
                          child: Icon(Icons.close, size: 20),
                          onPressed: () async {
                            await unpinMemo(pinnedMemos[index]);
                          },
                        )
                      ),
                    ],
                  )
                ),

                // Pinned Memo Name
                Container(
                  height: 102,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 2),
                  //decoration: BoxDecoration(color: Colors.greenAccent),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        shortenMemoName(pinnedMemos[index]['name']),
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Color(0xff323232),
                        ),
                      ),
                      Text(
                        timestampToDate(pinnedMemos[index]['createAt']),
                        style: TextStyle(fontSize: 17, color: Color(0xff808080)),
                      ),
                    ],
                  ),
                )
              ]
            )
          ),
        );
      },
    )
  );
}

String shortenMemoName(memoName) {
  var shortMemoName;
  memoName.length > 33 ? 
    shortMemoName = memoName.substring(0, 33) + '...'
    :
    shortMemoName = memoName;

  return shortMemoName;
}

String timestampToDate(timestamp) {
  var rawDate = timestamp.toDate().toString();
  var date = rawDate.split(" ")[0];

  return date;
}