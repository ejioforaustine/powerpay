import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:powerpay/Core/Functions/constantvaribles.dart';
import 'package:powerpay/Core/Navigation.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/Virtual%20Card/UI/PIN/resetPin.dart';
import 'package:powerpay/Virtual%20Card/UI/virtual%20card%20Home.dart';

import '../../Kvirtual constant.dart';
import 'PIN.dart';
class EnterPin extends StatefulWidget {
  const EnterPin({super.key});

  @override
  State<EnterPin> createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {

  Future<bool> _verifyPin(String enteredPin) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail!)
        .get();

    String storedHash = userDoc['pin_hash'];
    String enteredHash = hashPin(enteredPin);

    return storedHash == enteredHash;
  }

  String hashPin(String pin) {
    var bytes = utf8.encode(pin);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }



  final TextEditingController _textEditingController = TextEditingController();
  void _addToTextField(String value) {
    setState(() {
      _textEditingController.text += value;
    });
  }
  void _deleteFromTextField() {
    setState(() {
      if (_textEditingController.text.isNotEmpty) {
        _textEditingController.text = _textEditingController.text
            .substring(0, _textEditingController.text.length - 1);
      }
    });
  }
  void _updateFormattedValue(String value) {
    final numberFormat = NumberFormat("#,###");
    final unformattedValue = value.replaceAll(',', '');
    final formattedValue =
    numberFormat.format(int.tryParse(unformattedValue) ?? 0);
    setState(() {
      _textEditingController.text = formattedValue;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Enter PIN',
          style: GoogleFonts.inter(
              fontSize: 16/textScaleFactor,
              fontWeight: FontWeight.w700, color: ktextColor),
        ),
        centerTitle: true,

        backgroundColor: kbackgroundColorLightMode,
        iconTheme:  IconThemeData(color: ktextColor),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(100.0, 20, 100, 5),
            child: TextFormField(
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(prefixText: '  '),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsSeparatorInputFormatter(),
              ],
              readOnly: true,
              controller: _textEditingController,
              cursorHeight: 30,
              style: GoogleFonts.arimo(
                  fontWeight: FontWeight.w900,
                  color: ktextColor,
                  fontSize: 50),
            ),
          ),
          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('1');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('2');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '2',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('3');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '3',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('4');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '4',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('5');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '5',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('6');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '6',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('7');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '7',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(

                child: GestureDetector(
                  onTap: (){_addToTextField('8');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '8',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('9');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '9',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('.');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '.',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('0');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '0',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_deleteFromTextField();},
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Icon(Icons.backspace,color: ktextColor,),

                    ],
                  ),
                ),
              )
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 0.0,bottom: 20),
            child: GestureDetector(
              onTap: () async {
                bool isValid = await _verifyPin(_textEditingController.text);
                if (isValid) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const VirtualCardHomePage()));
                  // Proceed to sensitive feature
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid PIN")));
                }
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width/1.3,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.amber),
                child: Center(child: Text('Proceed',

                  style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 14/textScaleFactor),)),
              ),
            ),
          )



        ],
      ),
    );
  }
}


/// showmodal
Future enterPin(BuildContext context, Function() callState) {
  TextEditingController enterPinTextEditingController = TextEditingController();

  return showModalBottomSheet(
      context: context,
      backgroundColor: kbackgroundColorLightMode,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,

      builder: (BuildContext context) {
        bool pop = false;
        Future<bool> shouldPop() async {
          pop = false;
          return pop;
        }


        bool isValid = false;

        return WillPopScope(
            onWillPop: () async {

              return shouldPop();},

          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {


              void callState (){
                setState((){});
              }
              String hashPin(String pin) {
                var bytes = utf8.encode(pin);
                var digest = sha256.convert(bytes);
                return digest.toString();
              }
              Future<bool> verifyPin(String enteredPin) async {
                DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userEmail!)
                    .get();

                String storedHash = userDoc['pin_hash'];
                String enteredHash = hashPin(enteredPin);

                return storedHash == enteredHash;
              }


              void addToTextField(String value) {

                  enterPinTextEditingController.text += value;
              }
              void deleteFromTextField() {
                setState(() {
                  if (enterPinTextEditingController.text.isNotEmpty) {
                    enterPinTextEditingController.text = enterPinTextEditingController.text
                        .substring(0, enterPinTextEditingController.text.length - 1);
                  }
                });
              }
              bool button1auto = true;
              return Padding(
                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height/1.08,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enter PIN',
                            style: GoogleFonts.inter(
                                fontSize: 16/textScaleFactor,
                                fontWeight: FontWeight.w700, color: ktextColor),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100.0, 20, 100, 5),
                        child: TextFormField(
                          obscureText: true,
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(prefixText: '  '),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            ThousandsSeparatorInputFormatter(),
                          ],
                          readOnly: true,
                          controller: enterPinTextEditingController,
                          cursorHeight: 30,
                          style: GoogleFonts.arimo(
                              fontWeight: FontWeight.w900,
                              color: ktextColor,
                              fontSize: 50),
                        ),
                      ),
                      const Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                HapticFeedback.lightImpact();
                                addToTextField('1');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '1',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                HapticFeedback.lightImpact();
                                addToTextField('2');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '2',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){HapticFeedback.lightImpact();
                                addToTextField('3');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '3',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){HapticFeedback.lightImpact();
                                addToTextField('4');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '4',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                HapticFeedback.lightImpact();
                                addToTextField('5');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '5',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                HapticFeedback.lightImpact();
                                addToTextField('6');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '6',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){HapticFeedback.lightImpact();
                                addToTextField('7');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '7',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(

                            child: GestureDetector(
                              onTap: (){
                                HapticFeedback.lightImpact();
                                addToTextField('8');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '8',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                HapticFeedback.lightImpact();
                                addToTextField('9');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '9',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                HapticFeedback.lightImpact();
                                addToTextField('.');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '.',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                HapticFeedback.lightImpact();
                                addToTextField('0');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '0',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                HapticFeedback.lightImpact();
                                deleteFromTextField();},
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [
                                  Icon(Icons.backspace,color: ktextColor,),

                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap:(){
                              if(context.mounted){
                                Navigator.pop(context);
                                resetPin(context);
                              }
                            },
                            child: Text(
                              'Forgot PIN?',
                              style: GoogleFonts.inter(
                                  fontSize: 12/textScaleFactor,
                                  fontWeight: FontWeight.w700, color: ktextColor),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0,bottom: 20),
                        child: GestureDetector(
                          onTap: () async {
                            isValid = await verifyPin(enterPinTextEditingController.text);
                            if (isValid) {
                              Navigator.pop(context);
                              // Proceed to sensitive feature
                            } else {
                              AnimatedSnackBar(builder: (BuildContext context) {
                                return IntrinsicHeight(
                                  child: Container(
                                    width: screenWidth/1.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.black
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Invalid Pin.',style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 12/textScaleFactor,
                                                  fontWeight: FontWeight.w900),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text("Did you forget your Pin?, you can reset it below",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                      color: Colors.white,

                                                      fontSize: 8/textScaleFactor,
                                                      fontWeight: FontWeight.w200),),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );

                              }).show(context);
                              setState((){});
                            }
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width/1.3,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.amber),
                            child: Center(child: Text('Proceed',

                              style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 14/textScaleFactor),)),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              );
            },

          ),
        );
      });
}
