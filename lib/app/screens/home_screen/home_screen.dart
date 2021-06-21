import 'package:application/app/screens/messages_screen/messages_screen.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera_camera/camera_camera.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var ctrl = TextEditingController();
  bool toogle = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: toogle
              ? TextFormField(
                  controller: ctrl,
                  onFieldSubmitted: (value) {
                    setState(() {
                      toogle = false;
                      ctrl.clear();
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Buscar",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              : Text('Chat'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            toogle
                ? SizedBox()
                : IconButton(
                    icon: Icon(CupertinoIcons.search),
                    onPressed: () {
                      setState(() {
                        toogle = toogle ? false : true;
                      });
                    },
                  ),
          ],
          bottom: TabBar(
            labelPadding: EdgeInsets.only(left: 10, right: 10),
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.camera_alt,
                ),
              ),
              Tab(
                text: 'CONVERSAS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CameraCamera(
              onFile: (file) => print(file),
            ),
            MessagesScreen(),
          ],
        ),
      ),
    );
  }
}
