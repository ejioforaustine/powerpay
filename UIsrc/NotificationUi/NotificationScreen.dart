import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../home/Home.dart';


class Alerts extends StatefulWidget {
  Alerts({Key? key, this.messageTitle, this.messageBody,}) : super(key: key);

  var messageTitle ;
  var messageBody;


  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {

  final List<String> _Data = [];
  int key = 1;
  int keybody = 2;

  String generateUniqueKey() {
    var now = DateTime.now().microsecondsSinceEpoch;
    var rand = Random().nextInt(100000);
    return 'iD$now$rand';
  }

  String generateUniqueKeyBody() {
    var now = DateTime.now().microsecondsSinceEpoch;
    var rand = Random().nextInt(100000);
    return 'DesID$now$rand';
  }


  List<String?> stringList =[];
  List<String?> stringListBody =[];


  void SavetoLocaldevice() async {
    final prefs = await SharedPreferences.getInstance();

    String newStringKey = generateUniqueKey();
    String newStringKeyBody = generateUniqueKeyBody();

    if(passNotification = true)
    {widget.messageTitle == null ? print('Null') : prefs.setString(newStringKey, widget.messageTitle);
    widget.messageBody == null ? print('NullBody') : prefs.setString(newStringKeyBody, widget.messageBody) ;}



    var KeyLists = prefs.getKeys().where((key) => key.startsWith('iD')).toList();
    var KeyListsBody = prefs.getKeys().where((key2) => key2.startsWith('DesID')).toList();

    stringList = KeyLists.map((key) => prefs.getString(key)).toList();
    stringListBody = KeyListsBody.map((key) => prefs.getString(key)).toList();

    print(KeyLists);
    print(stringList.length);
    print(stringListBody);
    final value = prefs.getString(newStringKey);
    print(value); // 'value'
    final value2 = prefs.getString(newStringKeyBody);
    print(value2);
    passNotification = false;
    if(stringList.length >= 4){
      prefs.clear();
    }

    setState((){passNotification = false;});


  }


  @override
  void initState(){
    SavetoLocaldevice();

    Timer(const Duration(milliseconds: 500), () { setState((){});});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
        appBar: AppBar(
          title: Text('Notifications',style: GoogleFonts.kadwa(color: ktextColor,fontWeight: FontWeight.w900,fontSize: 17*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height),),
          backgroundColor: kbackgroundColorLightMode,
          centerTitle: true,
          iconTheme:  IconThemeData(color: ktextColor, size: 25*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height),
        ),
        body: ListView.builder(

          itemCount: stringList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                leading:  Icon(Icons.notifications,color: ktextColor,),
                title: Text(stringList[(stringList.length -1 )- index].toString(),style: GoogleFonts.kadwa(
                    color: ktextColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                ),),
                subtitle: Text(stringListBody[(stringList.length -1 )-index].toString(),style: GoogleFonts.kadwa(
                    color: ktextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                )),
              ),
            );
          },
        )
    );
  }
}