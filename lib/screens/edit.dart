import 'package:flutter/material.dart';
import 'package:imemo_mobile/screens/home.dart';
import 'package:imemo_mobile/widgets/appbar.dart';
import 'package:imemo_mobile/colors.dart';

class Edit extends StatefulWidget {
  final Map<String, dynamic> memoData;
  final int index;
  final Function updateMemo;
  
  Edit({
    Key key, 
    @required this.memoData, 
    @required this.index,
    @required this.updateMemo
  }) : super(key: key);

  @override 
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  var items = ['None', 'Work', 'Study', 'Trip', 'Family', 'Love'];
  String currentCategory;

  // TextField Controller
  final TextEditingController _memoNameController = TextEditingController();
  final TextEditingController _memoContentController = TextEditingController();
  
  Future<void> _updateMemo(String memoName, String memoContent) async {
    var updatedMemo = {
      'name': memoName,
      'category': currentCategory,
      'content': memoContent,
      'createAt': widget.memoData['createAt'],
      'pinned': widget.memoData['pinned'],
    };

    await widget.updateMemo(updatedMemo, widget.index);
  }

  @override
  void initState() {
    super.initState();
    _memoNameController.text = widget.memoData['name'];
    _memoContentController.text = widget.memoData['content'];
    currentCategory = widget.memoData['category'];
  }

  @override
  void dispose() {
    super.dispose();
    _memoNameController.dispose();
    _memoContentController.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: EditAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Memo Name Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
              
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
                        color: Color(0xff616161),
                      ),
                    ),
                  ),

                  // Dropdown List
                  Container(
                    height: 40,
                    width: 130,
                    //decoration: BoxDecoration(color: Colors.greenAccent),

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
                        hintText: 'Write a note...',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Update Memo Button
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
                  'Update',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () async {
                  await _updateMemo(
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