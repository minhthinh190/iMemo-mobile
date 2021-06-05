import 'package:flutter/material.dart';

class CreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override 
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
        AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          toolbarHeight: 100,
          iconTheme: IconThemeData(color: Color(0xff532d84)),
          title: Text(
            'New Memo',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xff440888),
            ),
          ),
          elevation: 0,
        )
      ]
    );
  }

  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class EditAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override 
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
        AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xff440888), size: 25),
          title: Text(
            'Edit Memo',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xff440888),
            ),
          ),
          elevation: 0,
        )
      ]
    );
  }

  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class MemoDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override 
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
        AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 90,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xff532d84)),
          title: Text(
            'Memo Details',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff440888),
            ),
          ),
          elevation: 0,
        )
      ]
    );
  }

  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class ActionAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Function callback;
  ActionAppbar({@required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          backgroundColor: Color(0xffc5cae9),
          toolbarHeight: 78,
          //centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xff440888)),
          title: Container(
            margin: EdgeInsets.only(left: 13),
            child: Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold, 
                color: Color(0xff440888)
              ),
            )
          ),
          elevation: 0,
          actions: <Widget>[
            PopupMenuButton(
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

              onSelected: (value) { this.callback(); },
              icon: Icon(Icons.segment),
            ),
          ],
        )
      ]
    );
  }

  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}